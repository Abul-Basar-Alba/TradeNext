-- Temporarily disable RLS for testing
-- Run this in Supabase SQL Editor

ALTER TABLE products DISABLE ROW LEVEL SECURITY;

-- Or if you want to keep RLS enabled but allow all operations:
DROP POLICY IF EXISTS "Authenticated users can create products" ON products;
DROP POLICY IF EXISTS "Owners can update their products" ON products;
DROP POLICY IF EXISTS "Owners can delete their products" ON products;

-- Create permissive policies
CREATE POLICY "Allow all inserts"
  ON products FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Allow all updates"
  ON products FOR UPDATE
  USING (true);

CREATE POLICY "Allow all deletes"
  ON products FOR DELETE
  USING (true);
