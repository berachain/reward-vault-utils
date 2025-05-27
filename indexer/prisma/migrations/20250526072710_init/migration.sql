-- CreateTable
CREATE TABLE "ButtonPress" (
    "id" TEXT NOT NULL,
    "address" TEXT NOT NULL,
    "timestamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "blockNumber" INTEGER NOT NULL,
    "txHash" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ButtonPress_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RewardDistribution" (
    "id" TEXT NOT NULL,
    "startTime" TIMESTAMP(3) NOT NULL,
    "endTime" TIMESTAMP(3) NOT NULL,
    "totalRewards" TEXT NOT NULL,
    "merkleRoot" TEXT NOT NULL,
    "merkleProofs" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "RewardDistribution_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "IndexerState" (
    "key" TEXT NOT NULL,
    "value" TEXT NOT NULL,

    CONSTRAINT "IndexerState_pkey" PRIMARY KEY ("key")
);

-- CreateTable
CREATE TABLE "MerkleClaim" (
    "id" TEXT NOT NULL,
    "merkleRoot" TEXT NOT NULL,
    "start" TIMESTAMP(3) NOT NULL,
    "end" TIMESTAMP(3) NOT NULL,
    "prizeAmount" TEXT NOT NULL,
    "participantCount" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "MerkleClaim_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MerkleParticipant" (
    "id" TEXT NOT NULL,
    "claimId" TEXT NOT NULL,
    "address" TEXT NOT NULL,
    "rewardAmount" TEXT NOT NULL,
    "proof" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "MerkleParticipant_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "ButtonPress_txHash_key" ON "ButtonPress"("txHash");

-- CreateIndex
CREATE INDEX "ButtonPress_address_idx" ON "ButtonPress"("address");

-- CreateIndex
CREATE INDEX "ButtonPress_timestamp_idx" ON "ButtonPress"("timestamp");

-- CreateIndex
CREATE INDEX "ButtonPress_blockNumber_idx" ON "ButtonPress"("blockNumber");

-- CreateIndex
CREATE INDEX "RewardDistribution_startTime_idx" ON "RewardDistribution"("startTime");

-- CreateIndex
CREATE INDEX "RewardDistribution_endTime_idx" ON "RewardDistribution"("endTime");

-- CreateIndex
CREATE UNIQUE INDEX "MerkleClaim_merkleRoot_key" ON "MerkleClaim"("merkleRoot");

-- CreateIndex
CREATE UNIQUE INDEX "MerkleParticipant_claimId_address_key" ON "MerkleParticipant"("claimId", "address");

-- AddForeignKey
ALTER TABLE "MerkleParticipant" ADD CONSTRAINT "MerkleParticipant_claimId_fkey" FOREIGN KEY ("claimId") REFERENCES "MerkleClaim"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
