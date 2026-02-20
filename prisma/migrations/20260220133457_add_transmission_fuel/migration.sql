/*
  Warnings:

  - You are about to drop the column `fuel` on the `Listing` table. All the data in the column will be lost.
  - You are about to drop the column `transmission` on the `Listing` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "Listing" DROP COLUMN "fuel",
DROP COLUMN "transmission",
ADD COLUMN     "fuelKey" TEXT,
ADD COLUMN     "missionKey" TEXT;

-- CreateTable
CREATE TABLE "Fuel" (
    "fKeyNo" TEXT NOT NULL,
    "fuelName" TEXT NOT NULL,

    CONSTRAINT "Fuel_pkey" PRIMARY KEY ("fKeyNo")
);

-- CreateTable
CREATE TABLE "Mission" (
    "mKeyNo" TEXT NOT NULL,
    "missionName" TEXT NOT NULL,

    CONSTRAINT "Mission_pkey" PRIMARY KEY ("mKeyNo")
);

-- CreateIndex
CREATE INDEX "Listing_fuelKey_idx" ON "Listing"("fuelKey");

-- CreateIndex
CREATE INDEX "Listing_missionKey_idx" ON "Listing"("missionKey");

-- AddForeignKey
ALTER TABLE "Listing" ADD CONSTRAINT "Listing_fuelKey_fkey" FOREIGN KEY ("fuelKey") REFERENCES "Fuel"("fKeyNo") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Listing" ADD CONSTRAINT "Listing_missionKey_fkey" FOREIGN KEY ("missionKey") REFERENCES "Mission"("mKeyNo") ON DELETE SET NULL ON UPDATE CASCADE;
