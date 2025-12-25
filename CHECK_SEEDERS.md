# How to Check and Verify Database Seeders

## Quick Commands

### 1. Check if seeders have been run (Central Database)

```bash
# Connect to the API container
docker compose exec api bash

# Check if seeders table exists and has entries
php artisan db:show

# Or check specific tables that should be seeded
php artisan tinker
# Then in tinker:
User::count()  # Should be > 0 if UserSeeder ran
Organization::count()  # Should be > 0 if OrganizationsSeeder ran
```

### 2. Run Central Seeders

```bash
# Run all central seeders
docker compose exec api php artisan db:seed

# Run a specific seeder
docker compose exec api php artisan db:seed --class=UserSeeder
docker compose exec api php artisan db:seed --class=OrganizationsSeeder
docker compose exec api php artisan db:seed --class=PlaceholderSeeder
docker compose exec api php artisan db:seed --class=PricePlansSeeder
docker compose exec api php artisan db:seed --class=ModuleSeeder
```

### 3. Check Tenant Seeders

```bash
# List all tenants
docker compose exec api php artisan tenants:list

# Run tenant seeders for all tenants
docker compose exec api php artisan tenants:seed

# Run tenant seeders for a specific tenant
docker compose exec api php artisan tenants:seed --tenants=<tenant_id>

# Run a specific tenant seeder
docker compose exec api php artisan tenants:seed --class=Database\\Seeders\\Tenant\\UserSeeder
docker compose exec api php artisan tenants:seed --class=Database\\Seeders\\Tenant\\PermissionSeeder
docker compose exec api php artisan tenants:seed --class=Database\\Seeders\\Tenant\\DropdownSeeder
```

### 4. Verify Seeded Data

```bash
# Enter tinker
docker compose exec api php artisan tinker

# Check central database data
User::count()
Organization::count()
\App\Models\Central\PricePlan::count()
\App\Models\Central\Module::count()

# Check tenant database data (for a specific tenant)
$tenant = \App\Models\Central\Tenant::first();
$tenant->run(function () {
    \App\Models\Tenant\User::count();
    \App\Models\Tenant\Permission::count();
    \App\Models\Tenant\Dropdown::count();
    \App\Models\Tenant\Tag::count();
    \App\Models\Tenant\Setting::count();
});
```

### 5. Fresh Seed (Reset and Reseed)

```bash
# WARNING: This will drop all tables and reseed
docker compose exec api php artisan migrate:fresh --seed

# For tenants (WARNING: Destructive)
docker compose exec api php artisan tenants:migrate-fresh --seed
```

## Available Seeders

### Central Seeders (from DatabaseSeeder):

- `UserSeeder` - Central users
- `PlaceholderSeeder` - Placeholder fields
- `PricePlansSeeder` - Pricing plans
- `ModuleSeeder` - Modules
- `OrganizationsSeeder` - Organizations

### Tenant Seeders (from TenantDatabaseSeeder):

- `UserSeeder` - Tenant users
- `PermissionSeeder` - Permissions
- `DropdownSeeder` - Dropdown options
- `TagSeeder` - Tags
- `SettingSeeder` - Settings
- `PlaceholderSeeder` - Placeholder fields
- `AuthorizationSeeder` - Authorization rules
- `ChannelSeeder` - Channels
- `FilterSeeder` - Filters
- `ProgramSeeder` - Programs

## Quick Verification Script

Create a simple verification:

```bash
docker compose exec api php artisan tinker <<EOF
echo "=== Central Database ===" . PHP_EOL;
echo "Users: " . \App\Models\Central\User::count() . PHP_EOL;
echo "Organizations: " . \App\Models\Central\Organization::count() . PHP_EOL;
echo "Tenants: " . \App\Models\Central\Tenant::count() . PHP_EOL;

\$tenant = \App\Models\Central\Tenant::first();
if (\$tenant) {
    echo PHP_EOL . "=== Tenant Database (ID: " . \$tenant->id . ") ===" . PHP_EOL;
    \$tenant->run(function () {
        echo "Users: " . \App\Models\Tenant\User::count() . PHP_EOL;
        echo "Permissions: " . \App\Models\Tenant\Permission::count() . PHP_EOL;
        echo "Dropdowns: " . \App\Models\Tenant\Dropdown::count() . PHP_EOL;
    });
}
EOF
```
