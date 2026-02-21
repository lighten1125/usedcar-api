/*
  Warnings:

  - You are about to drop the column `color` on the `Listing` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "Listing" DROP COLUMN "color",
ADD COLUMN     "colorKey" TEXT,
ADD COLUMN     "plateNo" TEXT,
ADD COLUMN     "vin" TEXT;

-- CreateTable
CREATE TABLE "Color" (
    "cKeyNo" TEXT NOT NULL,
    "colorName" TEXT NOT NULL,

    CONSTRAINT "Color_pkey" PRIMARY KEY ("cKeyNo")
);

-- CreateIndex
CREATE INDEX "Listing_plateNo_idx" ON "Listing"("plateNo");

-- CreateIndex
CREATE INDEX "Listing_complexId_status_idx" ON "Listing"("complexId", "status");

-- CreateIndex
CREATE INDEX "Listing_colorKey_idx" ON "Listing"("colorKey");

-- CreateIndex
CREATE INDEX "Listing_price_idx" ON "Listing"("price");

-- CreateIndex
CREATE INDEX "Listing_yymm_idx" ON "Listing"("yymm");

-- CreateIndex
CREATE INDEX "Listing_km_idx" ON "Listing"("km");

-- AddForeignKey
ALTER TABLE "Listing" ADD CONSTRAINT "Listing_colorKey_fkey" FOREIGN KEY ("colorKey") REFERENCES "Color"("cKeyNo") ON DELETE SET NULL ON UPDATE CASCADE;
