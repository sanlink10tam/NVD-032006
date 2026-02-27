-- 1. Bảng Users (Người dùng)
CREATE TABLE IF NOT EXISTS users (
    id TEXT PRIMARY KEY,
    phone TEXT UNIQUE NOT NULL,
    "fullName" TEXT,
    "idNumber" TEXT,
    balance BIGINT DEFAULT 2000000,
    "totalLimit" BIGINT DEFAULT 2000000,
    rank TEXT DEFAULT 'standard',
    "rankProgress" INTEGER DEFAULT 0,
    "isLoggedIn" BOOLEAN DEFAULT false,
    "isAdmin" BOOLEAN DEFAULT false,
    "pendingUpgradeRank" TEXT,
    "rankUpgradeBill" TEXT,
    address TEXT,
    "joinDate" TEXT,
    "idFront" TEXT,
    "idBack" TEXT,
    "refZalo" TEXT,
    relationship TEXT,
    "lastLoanSeq" INTEGER DEFAULT 0,
    "bankName" TEXT,
    "bankAccountNumber" TEXT,
    "bankAccountHolder" TEXT,
    "updatedAt" BIGINT
);

-- 2. Bảng Loans (Khoản vay)
CREATE TABLE IF NOT EXISTS loans (
    id TEXT PRIMARY KEY,
    "userId" TEXT REFERENCES users(id) ON DELETE CASCADE,
    "userName" TEXT,
    amount BIGINT,
    date TEXT,
    "createdAt" TEXT,
    status TEXT,
    fine BIGINT DEFAULT 0,
    "billImage" TEXT,
    signature TEXT,
    "rejectionReason" TEXT,
    "updatedAt" BIGINT
);

-- 3. Bảng Notifications (Thông báo)
CREATE TABLE IF NOT EXISTS notifications (
    id TEXT PRIMARY KEY,
    "userId" TEXT REFERENCES users(id) ON DELETE CASCADE,
    title TEXT,
    message TEXT,
    time TEXT,
    read BOOLEAN DEFAULT false,
    type TEXT
);

-- 4. Bảng Config (Cấu hình hệ thống)
CREATE TABLE IF NOT EXISTS config (
    key TEXT PRIMARY KEY,
    value JSONB
);

-- Chèn dữ liệu cấu hình mặc định
INSERT INTO config (key, value) VALUES ('budget', '30000000') ON CONFLICT (key) DO NOTHING;
INSERT INTO config (key, value) VALUES ('rankProfit', '0') ON CONFLICT (key) DO NOTHING;
INSERT INTO config (key, value) VALUES ('loanProfit', '0') ON CONFLICT (key) DO NOTHING;

-- Tắt RLS (Row Level Security) để đơn giản hóa cho bản demo 
-- (Trong thực tế nên cấu hình RLS chi tiết hơn)
ALTER TABLE users DISABLE ROW LEVEL SECURITY;
ALTER TABLE loans DISABLE ROW LEVEL SECURITY;
ALTER TABLE notifications DISABLE ROW LEVEL SECURITY;
ALTER TABLE config DISABLE ROW LEVEL SECURITY;
