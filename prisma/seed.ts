import { PrismaClient } from "@prisma/client";
import fs from "fs";
import path from "path";

const prisma = new PrismaClient();

type CsvRow = Record<string, string>;

function parseCsv(filePath: string): CsvRow[] {
  const raw = fs.readFileSync(filePath, "utf-8").trim();
  const [headerLine, ...lines] = raw.split(/\r?\n/);
  const headers = headerLine.split(",").map(s => s.trim());

  return lines
    .filter(Boolean)
    .map(line => {
      // 아주 단순 CSV (너 파일은 따옴표/콤마 복잡하지 않아서 이걸로 충분)
      const cols = line.split(",").map(s => s.trim());
      const row: CsvRow = {};
      headers.forEach((h, i) => (row[h] = cols[i] ?? ""));
      return row;
    });
}

function clean(v?: string | null) {
  if (!v) return "";
  return String(v).replace(/^"|"$/g, "").trim();
}

async function seedFuels() {
  const file = path.join(process.cwd(), "prisma", "seed", "mpark_fuels.csv");
  if (!fs.existsSync(file)) return;

  const rows = parseCsv(file);
  for (const r of rows) {
    const code = r.code || r.fuelCode;
    const name = r.name || r.fuelName;
    if (!code || !name) continue;

    await prisma.mpFuel.upsert({
      where: { code },
      update: { name },
      create: { code, name },
    });
  }
  console.log("✅ seeded MpFuel:", rows.length);
}

async function seedTransmissions() {
  const file = path.join(process.cwd(), "prisma", "seed", "mpark_transmissions.csv");
  if (!fs.existsSync(file)) return;

  const rows = parseCsv(file);
  for (const r of rows) {
    const code = r.code || r.autoCode || r.transmissionCode;
    const name = r.name || r.autoName || r.transmissionName;
    if (!code || !name) continue;

    await prisma.mpTransmission.upsert({
      where: { code },
      update: { name },
      create: { code, name },
    });
  }
  console.log("✅ seeded MpTransmission:", rows.length);
}

async function seedColors() {
  const file = path.join(process.cwd(), "prisma", "seed", "mpark_colors.csv");
  if (!fs.existsSync(file)) return;

  const rows = parseCsv(file);
  for (const r of rows) {
    const code = r.code;
    const name = r.name || r.codeName;
    const rgbCode = r.rgbCode || r.rgb || "";

    if (!code || !name) continue;

    await prisma.mpColor.upsert({
      where: { code },
      update: { name, rgbCode: rgbCode || null },
      create: { code, name, rgbCode: rgbCode || null },
    });
  }
  console.log("✅ seeded MpColor:", rows.length);
}

async function seedCarTree() {
  const file = path.join(process.cwd(), "prisma", "seed", "mpark_car_tree.csv");
  if (!fs.existsSync(file)) return;

  const rows = parseCsv(file);

  const nodeMap = new Map();

  // ✅ 국산 제조사 코드
  const DOMESTIC_CODES = new Set(["A2", "A5", "A146", "A1", "A4", "A3", "A999"]);

  for (const r of rows) {
    const makerCode = clean(r.makerCode);
    const makerName = clean(r.makerName);

    const modelCode = clean(r.modelCode);
    const modelName = clean(r.modelName);

    const modelDetailCode = clean(r.modelDetailCode);
    const modelDetailName = clean(r.modelDetailName);
    const modelDetailYearLabel = clean(r.modelDetailYearLabel);

    const gradeCode = clean(r.gradeCode);
    const gradeName = clean(r.gradeName);
    const gradeYearLabel = clean(r.gradeYearLabel);

    const gradeDetailCode = clean(r.gradeDetailCode);
    const gradeDetailName = clean(r.gradeDetailName);
    const gradeDetailYearLabel = clean(r.gradeDetailYearLabel);

    if (makerCode) {
      nodeMap.set(makerCode, {
        code: makerCode,
        role: "MAKER",
        name: makerName,
        yearLabel: null,
        parentCode: null,
        makerGroup: DOMESTIC_CODES.has(makerCode) ? "DOMESTIC" : "IMPORT",
      });
    }

    if (modelCode) {
      nodeMap.set(modelCode, {
        code: modelCode,
        role: "MODEL",
        name: modelName,
        yearLabel: null,
        parentCode: makerCode,
        makerGroup: null,
      });
    }

    if (modelDetailCode) {
      nodeMap.set(modelDetailCode, {
        code: modelDetailCode,
        role: "MODEL_DETAIL",
        name: modelDetailName,
        yearLabel: modelDetailYearLabel,
        parentCode: modelCode,
        makerGroup: null,
      });
    }

    if (gradeCode) {
      nodeMap.set(gradeCode, {
        code: gradeCode,
        role: "GRADE",
        name: gradeName,
        yearLabel: gradeYearLabel,
        parentCode: modelDetailCode,
        makerGroup: null,
      });
    }

    if (gradeDetailCode) {
      nodeMap.set(gradeDetailCode, {
        code: gradeDetailCode,
        role: "GRADE_DETAIL",
        name: gradeDetailName,
        yearLabel: gradeDetailYearLabel,
        parentCode: gradeCode,
        makerGroup: null,
      });
    }
  }

  const nodes = [...nodeMap.values()];

  const roleOrder = [
    "MAKER",
    "MODEL",
    "MODEL_DETAIL",
    "GRADE",
    "GRADE_DETAIL",
  ] as const;

  for (const role of roleOrder) {
    const filtered = nodes.filter((n) => n.role === role);

    for (const n of filtered) {
      await prisma.mpNode.upsert({
        where: { code: n.code },
        update: {
          role: n.role,
          name: n.name,
          yearLabel: n.yearLabel,
          parentCode: n.parentCode,
          makerGroup: n.makerGroup,
        },
        create: {
          code: n.code,
          role: n.role,
          name: n.name,
          yearLabel: n.yearLabel,
          parentCode: n.parentCode,
          makerGroup: n.makerGroup,
        },
      });
    }

    console.log(`✅ seeded ${role}: ${filtered.length}`);
  }

  console.log("✅ seeded MpNode:", nodes.length);
}

async function main() {
  await seedFuels();
  await seedTransmissions();
  await seedColors();
  await seedCarTree();
}

main()
  .then(async () => {
    await prisma.$disconnect();
    console.log("DONE ✅");
  })
  .catch(async (e) => {
    console.error(e);
    await prisma.$disconnect();
    process.exit(1);
  });