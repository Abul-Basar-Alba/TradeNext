-- ==========================================
-- TradeNest Database Schema for Supabase
-- ==========================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ==========================================
-- PRODUCTS TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS products (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title VARCHAR(255) NOT NULL,
  description TEXT,
  price DECIMAL(10, 2) NOT NULL,
  category VARCHAR(100) NOT NULL,
  type VARCHAR(50) NOT NULL CHECK (type IN ('sell', 'rent')),
  condition VARCHAR(50) CHECK (condition IN ('new', 'like_new', 'good', 'fair')),
  status VARCHAR(50) DEFAULT 'active' CHECK (status IN ('active', 'sold', 'rented', 'unavailable')),
  
  -- Owner information (Firebase Auth UID)
  owner_id VARCHAR(255) NOT NULL,
  owner_name VARCHAR(255),
  owner_phone VARCHAR(20),
  owner_email VARCHAR(255),
  
  -- Location
  location VARCHAR(255),
  division VARCHAR(100),
  district VARCHAR(100),
  
  -- Images (array of URLs from Supabase Storage)
  images TEXT[] DEFAULT '{}',
  
  -- Additional fields
  featured BOOLEAN DEFAULT FALSE,
  views INTEGER DEFAULT 0,
  
  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ==========================================
-- FAVORITES TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS favorites (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id VARCHAR(255) NOT NULL,
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  UNIQUE(user_id, product_id)
);

-- ==========================================
-- CHATS TABLE (Future feature)
-- ==========================================
CREATE TABLE IF NOT EXISTS chats (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  product_id UUID REFERENCES products(id) ON DELETE CASCADE,
  buyer_id VARCHAR(255) NOT NULL,
  seller_id VARCHAR(255) NOT NULL,
  last_message TEXT,
  last_message_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  UNIQUE(product_id, buyer_id, seller_id)
);

-- ==========================================
-- MESSAGES TABLE (Future feature)
-- ==========================================
CREATE TABLE IF NOT EXISTS messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  chat_id UUID NOT NULL REFERENCES chats(id) ON DELETE CASCADE,
  sender_id VARCHAR(255) NOT NULL,
  message TEXT NOT NULL,
  read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ==========================================
-- INDEXES for Performance
-- ==========================================
CREATE INDEX IF NOT EXISTS idx_products_owner_id ON products(owner_id);
CREATE INDEX IF NOT EXISTS idx_products_category ON products(category);
CREATE INDEX IF NOT EXISTS idx_products_type ON products(type);
CREATE INDEX IF NOT EXISTS idx_products_status ON products(status);
CREATE INDEX IF NOT EXISTS idx_products_created_at ON products(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_favorites_user_id ON favorites(user_id);
CREATE INDEX IF NOT EXISTS idx_favorites_product_id ON favorites(product_id);
CREATE INDEX IF NOT EXISTS idx_messages_chat_id ON messages(chat_id);

-- ==========================================
-- ROW LEVEL SECURITY (RLS) Policies
-- ==========================================

-- Enable RLS on all tables
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE chats ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

-- Products: Everyone can read, only owner can update/delete
CREATE POLICY "Anyone can view products"
  ON products FOR SELECT
  USING (true);

CREATE POLICY "Authenticated users can create products"
  ON products FOR INSERT
  WITH CHECK (auth.uid()::text = owner_id);

CREATE POLICY "Owners can update their products"
  ON products FOR UPDATE
  USING (auth.uid()::text = owner_id);

CREATE POLICY "Owners can delete their products"
  ON products FOR DELETE
  USING (auth.uid()::text = owner_id);

-- Favorites: Users can manage their own favorites
CREATE POLICY "Users can view their favorites"
  ON favorites FOR SELECT
  USING (auth.uid()::text = user_id);

CREATE POLICY "Users can add favorites"
  ON favorites FOR INSERT
  WITH CHECK (auth.uid()::text = user_id);

CREATE POLICY "Users can remove favorites"
  ON favorites FOR DELETE
  USING (auth.uid()::text = user_id);

-- Chats: Users can view chats they're part of
CREATE POLICY "Users can view their chats"
  ON chats FOR SELECT
  USING (auth.uid()::text = buyer_id OR auth.uid()::text = seller_id);

CREATE POLICY "Users can create chats"
  ON chats FOR INSERT
  WITH CHECK (auth.uid()::text = buyer_id);

-- Messages: Users can view messages in their chats
CREATE POLICY "Users can view chat messages"
  ON messages FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM chats
      WHERE chats.id = messages.chat_id
      AND (chats.buyer_id = auth.uid()::text OR chats.seller_id = auth.uid()::text)
    )
  );

CREATE POLICY "Users can send messages"
  ON messages FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM chats
      WHERE chats.id = chat_id
      AND (chats.buyer_id = auth.uid()::text OR chats.seller_id = auth.uid()::text)
    )
  );

-- ==========================================
-- FUNCTIONS
-- ==========================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger to auto-update updated_at
CREATE TRIGGER update_products_updated_at
  BEFORE UPDATE ON products
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ==========================================
-- Sample Data (Optional - for testing)
-- ==========================================
/*
INSERT INTO products (title, description, price, category, type, owner_id, owner_name, owner_phone, location, images)
VALUES 
  ('Samsung Galaxy S21', 'Excellent condition, 8GB RAM, 128GB Storage', 45000, 'electronics', 'sell', 'sample_user_id', 'John Doe', '01712345678', 'Dhaka', ARRAY['https://example.com/image1.jpg']),
  ('Toyota Corolla 2020', 'Well maintained, only 20,000 km driven', 2500000, 'vehicles', 'sell', 'sample_user_id', 'Jane Smith', '01812345678', 'Chittagong', ARRAY['https://example.com/car1.jpg']),
  ('2 Bed Apartment', 'Spacious apartment in Gulshan area', 35000, 'property', 'rent', 'sample_user_id', 'Mike Wilson', '01912345678', 'Dhaka', ARRAY['https://example.com/apt1.jpg']);
*/
