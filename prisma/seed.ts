import { PrismaClient } from "@prisma/client"

const prisma = new PrismaClient()

async function main() {

  // 1. 제조사
  await prisma.carMaker.upsert({
    where: { makerNo: "10116" }, // 제네시스
    update: {},
    create: {
      makerNo: "10116",
      makerName: "제네시스",
    }
  })

  // 2. 모델 (G80)
  await prisma.carModel.upsert({
    where: { modelNo: "101001" },
    update: {},
    create: {
      modelNo: "101001",
      makerNo: "10116",
      modelName: "G80",
    }
  })

  // 3. 세부모델 (G80 RG3)
  await prisma.carModelDetail.upsert({
    where: { mDetailNo: "1002739" },
    update: {},
    create: {
      mDetailNo: "1002739",
      modelNo: "101001",
      mDetailName: "G80(RG3)",
    }
  })

  // 4. 등급 (예시 GradeNo 하나)
  await prisma.carGrade.upsert({
    where: { gradeNo: "10013458" },
    update: {},
    create: {
      gradeNo: "10013458",
      mDetailNo: "1002739",
      gradeCode: "11",
      gradeName: "2.5T AWD",
    }
  })

  // 5. 세부등급
  await prisma.carGradeDetail.upsert({
    where: { gDetailNo: "100013845" },
    update: {},
    create: {
      gDetailNo: "100013845",
      gradeNo: "10013458",
      gDetailName: "기본형",
    }
  })

  await prisma.carGradeDetail.upsert({
    where: { gDetailNo: "100013846" },
    update: {},
    create: {
      gDetailNo: "100013846",
      gradeNo: "10013458",
      gDetailName: "스포츠팩",
    }
  })

  console.log("Seed 완료 🚀")
}

main()
  .catch(console.error)
  .finally(() => prisma.$disconnect())
  console.log(await prisma.$queryRaw`select current_database() as db, current_schema() as schema`);

