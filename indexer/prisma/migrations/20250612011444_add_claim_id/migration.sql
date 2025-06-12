/*
  Warnings:

  - A unique constraint covering the columns `[claimId]` on the table `MerkleClaim` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `claimId` to the `MerkleClaim` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "MerkleParticipant" DROP CONSTRAINT "MerkleParticipant_claimId_fkey";

-- AlterTable
ALTER TABLE "MerkleClaim" ADD COLUMN     "claimId" TEXT NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX "MerkleClaim_claimId_key" ON "MerkleClaim"("claimId");

-- AddForeignKey
ALTER TABLE "MerkleParticipant" ADD CONSTRAINT "MerkleParticipant_claimId_fkey" FOREIGN KEY ("claimId") REFERENCES "MerkleClaim"("claimId") ON DELETE RESTRICT ON UPDATE CASCADE;
