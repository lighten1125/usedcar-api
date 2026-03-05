-- CreateEnum
CREATE TYPE "ListingStatus" AS ENUM ('ACTIVE', 'SOLD_PENDING_DELETE', 'SOLD_CONFIRMED', 'DELETED');

-- CreateEnum
CREATE TYPE "MpRole" AS ENUM ('MAKER', 'MODEL', 'MODEL_DETAIL', 'GRADE', 'GRADE_DETAIL');

-- CreateTable
CREATE TABLE "MpNode" (
    "code" TEXT NOT NULL,
    "role" "MpRole" NOT NULL,
    "name" TEXT,
    "yearLabel" TEXT,
    "releaseYear" INTEGER,
    "parentCode" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "MpNode_pkey" PRIMARY KEY ("code")
);

-- CreateTable
CREATE TABLE "Listing" (
    "id" SERIAL NOT NULL,
    "source" TEXT NOT NULL DEFAULT 'MPARK',
    "sourceListingId" TEXT NOT NULL,
    "makerCode" TEXT NOT NULL,
    "modelCode" TEXT NOT NULL,
    "modelDetailCode" TEXT NOT NULL,
    "gradeCode" TEXT,
    "gradeDetailCode" TEXT,
    "modelDetailDisplay" TEXT,
    "gradeDisplay" TEXT,
    "gradeDetailDisplay" TEXT,
    "plateNo" TEXT,
    "vin" TEXT,
    "vehicleKey" TEXT,
    "yymm" TEXT,
    "km" INTEGER,
    "price" INTEGER,
    "fuelCode" TEXT,
    "transmissionCode" TEXT,
    "colorCode" TEXT,
    "url" TEXT,
    "status" "ListingStatus" NOT NULL DEFAULT 'ACTIVE',
    "firstSeenAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastSeenAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "soldPendingAt" TIMESTAMP(3),
    "deletedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Listing_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MpColor" (
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "rgbCode" TEXT,

    CONSTRAINT "MpColor_pkey" PRIMARY KEY ("code")
);

-- CreateTable
CREATE TABLE "MpFuel" (
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "MpFuel_pkey" PRIMARY KEY ("code")
);

-- CreateTable
CREATE TABLE "MpTransmission" (
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "MpTransmission_pkey" PRIMARY KEY ("code")
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
CREATE INDEX "MpNode_role_idx" ON "MpNode"("role");

-- CreateIndex
CREATE INDEX "MpNode_parentCode_idx" ON "MpNode"("parentCode");

-- CreateIndex
CREATE UNIQUE INDEX "Listing_sourceListingId_key" ON "Listing"("sourceListingId");

-- CreateIndex
CREATE INDEX "Listing_makerCode_idx" ON "Listing"("makerCode");

-- CreateIndex
CREATE INDEX "Listing_modelCode_idx" ON "Listing"("modelCode");

-- CreateIndex
CREATE INDEX "Listing_modelDetailCode_idx" ON "Listing"("modelDetailCode");

-- CreateIndex
CREATE INDEX "Listing_makerCode_modelCode_modelDetailCode_idx" ON "Listing"("makerCode", "modelCode", "modelDetailCode");

-- CreateIndex
CREATE INDEX "Listing_gradeCode_idx" ON "Listing"("gradeCode");

-- CreateIndex
CREATE INDEX "Listing_gradeDetailCode_idx" ON "Listing"("gradeDetailCode");

-- CreateIndex
CREATE INDEX "Listing_fuelCode_idx" ON "Listing"("fuelCode");

-- CreateIndex
CREATE INDEX "Listing_transmissionCode_idx" ON "Listing"("transmissionCode");

-- CreateIndex
CREATE INDEX "Listing_colorCode_idx" ON "Listing"("colorCode");

-- CreateIndex
CREATE INDEX "Listing_vehicleKey_idx" ON "Listing"("vehicleKey");

-- CreateIndex
CREATE INDEX "Listing_plateNo_idx" ON "Listing"("plateNo");

-- CreateIndex
CREATE INDEX "Listing_price_idx" ON "Listing"("price");

-- CreateIndex
CREATE INDEX "Listing_yymm_idx" ON "Listing"("yymm");

-- CreateIndex
CREATE INDEX "Listing_km_idx" ON "Listing"("km");

-- CreateIndex
CREATE INDEX "Listing_status_lastSeenAt_idx" ON "Listing"("status", "lastSeenAt");

-- CreateIndex
CREATE UNIQUE INDEX "MySale_listingId_key" ON "MySale"("listingId");

-- AddForeignKey
ALTER TABLE "MpNode" ADD CONSTRAINT "MpNode_parentCode_fkey" FOREIGN KEY ("parentCode") REFERENCES "MpNode"("code") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Listing" ADD CONSTRAINT "Listing_fuelCode_fkey" FOREIGN KEY ("fuelCode") REFERENCES "MpFuel"("code") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Listing" ADD CONSTRAINT "Listing_transmissionCode_fkey" FOREIGN KEY ("transmissionCode") REFERENCES "MpTransmission"("code") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Listing" ADD CONSTRAINT "Listing_colorCode_fkey" FOREIGN KEY ("colorCode") REFERENCES "MpColor"("code") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MySale" ADD CONSTRAINT "MySale_listingId_fkey" FOREIGN KEY ("listingId") REFERENCES "Listing"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
