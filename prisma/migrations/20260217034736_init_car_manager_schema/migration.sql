/*
  Warnings:

  - You are about to drop the `Brand` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Model` table. If the table is not empty, all the data it contains will be lost.

*/
-- CreateEnum
CREATE TYPE "ListingStatus" AS ENUM ('ACTIVE', 'SOLD_PENDING_DELETE', 'SOLD_CONFIRMED', 'DELETED');

-- DropForeignKey
ALTER TABLE "Model" DROP CONSTRAINT "Model_brandId_fkey";

-- DropTable
DROP TABLE "Brand";

-- DropTable
DROP TABLE "Model";

-- CreateTable
CREATE TABLE "CarMaker" (
    "makerNo" TEXT NOT NULL,
    "makerName" TEXT NOT NULL,

    CONSTRAINT "CarMaker_pkey" PRIMARY KEY ("makerNo")
);

-- CreateTable
CREATE TABLE "CarModel" (
    "modelNo" TEXT NOT NULL,
    "makerNo" TEXT NOT NULL,
    "modelName" TEXT NOT NULL,

    CONSTRAINT "CarModel_pkey" PRIMARY KEY ("modelNo")
);

-- CreateTable
CREATE TABLE "CarModelDetail" (
    "mDetailNo" TEXT NOT NULL,
    "modelNo" TEXT NOT NULL,
    "mDetailName" TEXT NOT NULL,

    CONSTRAINT "CarModelDetail_pkey" PRIMARY KEY ("mDetailNo")
);

-- CreateTable
CREATE TABLE "CarGrade" (
    "gradeNo" TEXT NOT NULL,
    "mDetailNo" TEXT NOT NULL,
    "gradeCode" TEXT,
    "gradeName" TEXT,

    CONSTRAINT "CarGrade_pkey" PRIMARY KEY ("gradeNo")
);

-- CreateTable
CREATE TABLE "CarGradeDetail" (
    "gDetailNo" TEXT NOT NULL,
    "gradeNo" TEXT NOT NULL,
    "gDetailName" TEXT NOT NULL,

    CONSTRAINT "CarGradeDetail_pkey" PRIMARY KEY ("gDetailNo")
);

-- CreateTable
CREATE TABLE "Complex" (
    "id" SERIAL NOT NULL,
    "sido" TEXT,
    "sigungu" TEXT,
    "complexName" TEXT NOT NULL,

    CONSTRAINT "Complex_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Listing" (
    "id" SERIAL NOT NULL,
    "source" TEXT NOT NULL,
    "sourceListingId" TEXT NOT NULL,
    "vehicleKey" TEXT NOT NULL,
    "complexId" INTEGER,
    "gDetailNo" TEXT,
    "yymm" TEXT,
    "fuel" TEXT,
    "transmission" TEXT,
    "color" TEXT,
    "km" INTEGER,
    "price" INTEGER,
    "status" "ListingStatus" NOT NULL DEFAULT 'ACTIVE',
    "firstSeenAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastSeenAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "soldPendingAt" TIMESTAMP(3),
    "deletedAt" TIMESTAMP(3),
    "displayTitle" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Listing_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MySale" (
    "id" SERIAL NOT NULL,
    "listingId" INTEGER NOT NULL,
    "soldAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "soldPrice" INTEGER,
    "memo" TEXT,

    CONSTRAINT "MySale_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "CarModel_makerNo_idx" ON "CarModel"("makerNo");

-- CreateIndex
CREATE INDEX "CarModelDetail_modelNo_idx" ON "CarModelDetail"("modelNo");

-- CreateIndex
CREATE INDEX "CarGrade_mDetailNo_idx" ON "CarGrade"("mDetailNo");

-- CreateIndex
CREATE INDEX "CarGradeDetail_gradeNo_idx" ON "CarGradeDetail"("gradeNo");

-- CreateIndex
CREATE INDEX "Complex_complexName_idx" ON "Complex"("complexName");

-- CreateIndex
CREATE UNIQUE INDEX "Listing_sourceListingId_key" ON "Listing"("sourceListingId");

-- CreateIndex
CREATE INDEX "Listing_vehicleKey_idx" ON "Listing"("vehicleKey");

-- CreateIndex
CREATE INDEX "Listing_status_lastSeenAt_idx" ON "Listing"("status", "lastSeenAt");

-- CreateIndex
CREATE UNIQUE INDEX "MySale_listingId_key" ON "MySale"("listingId");

-- AddForeignKey
ALTER TABLE "CarModel" ADD CONSTRAINT "CarModel_makerNo_fkey" FOREIGN KEY ("makerNo") REFERENCES "CarMaker"("makerNo") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CarModelDetail" ADD CONSTRAINT "CarModelDetail_modelNo_fkey" FOREIGN KEY ("modelNo") REFERENCES "CarModel"("modelNo") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CarGrade" ADD CONSTRAINT "CarGrade_mDetailNo_fkey" FOREIGN KEY ("mDetailNo") REFERENCES "CarModelDetail"("mDetailNo") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CarGradeDetail" ADD CONSTRAINT "CarGradeDetail_gradeNo_fkey" FOREIGN KEY ("gradeNo") REFERENCES "CarGrade"("gradeNo") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Listing" ADD CONSTRAINT "Listing_complexId_fkey" FOREIGN KEY ("complexId") REFERENCES "Complex"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Listing" ADD CONSTRAINT "Listing_gDetailNo_fkey" FOREIGN KEY ("gDetailNo") REFERENCES "CarGradeDetail"("gDetailNo") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MySale" ADD CONSTRAINT "MySale_listingId_fkey" FOREIGN KEY ("listingId") REFERENCES "Listing"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
