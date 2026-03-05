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

async function main() {
  await seedFuels();
  await seedTransmissions();
  await seedColors();
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