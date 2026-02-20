const { PrismaClient } = require("@prisma/client");

const prisma = new PrismaClient();

async function main() {
  // Raw SQL로 현대 브랜드 + 모델 조회
  const result = await prisma.$queryRaw`
    SELECT b.name AS brand, m.name AS model
    FROM "Model" m
    JOIN "Brand" b ON b.id = m."brandId"
    WHERE b.name = '현대'
  `;

  console.log(result);
}

main()
  .catch((e) => {
    console.error(e);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
