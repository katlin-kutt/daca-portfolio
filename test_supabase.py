from supabase import create_client
 
# Asenda oma Supabase andmetega (Connect > API Keys)
url = "https://medpryxmbxpqcgilespv.supabase.co"
key = "sb_publishable_NzvMEq8w7mvvwZHWXTOY7w_FvUVzyDn"
 
supabase = create_client(url, key)
 
# Asenda oma tabeli nimega (nt 'test_sales' või 'team_members')
response = supabase.table('sales_test').select("*").execute()
 
print(f"Leitud ridu: {len(response.data)}")
for row in response.data:
    print(row)



