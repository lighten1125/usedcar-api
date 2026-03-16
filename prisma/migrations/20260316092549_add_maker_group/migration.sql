-- CreateEnum
CREATE TYPE "MakerGroup" AS ENUM ('DOMESTIC', 'IMPORT');

-- AlterTable
ALTER TABLE "MpNode" ADD COLUMN     "makerGroup" "MakerGroup";

-- CreateIndex
CREATE INDEX "MpNode_makerGroup_idx" ON "MpNode"("makerGroup");
