# VPS Update Instructions

## Quick Update (If directory already exists)

If you already have the `pikkar_admin_panel` directory on your VPS:

```bash
cd /path/to/pikkar_admin_panel
git pull origin main
npm install
pm2 restart pikkar-api  # or your restart command
```

## Full Migration (From admin_panel to pikkar_admin_panel)

### Option 1: Update Existing Directory

```bash
# 1. Navigate to your current admin_panel directory
cd /path/to/admin_panel

# 2. Update remote URL to new repository
git remote set-url origin https://github.com/kxaviera/pikkar_admin_panel.git

# 3. Fetch and pull latest changes
git fetch origin
git pull origin main

# 4. Install dependencies
npm install

# 5. Restart service
pm2 restart pikkar-api  # or: sudo systemctl restart pikkar-api
```

### Option 2: Fresh Clone (Recommended)

```bash
# 1. Backup current directory (optional but recommended)
cp -r /path/to/admin_panel /path/to/admin_panel_backup_$(date +%Y%m%d)

# 2. Clone the new repository
cd /path/to
git clone https://github.com/kxaviera/pikkar_admin_panel.git

# 3. Copy environment variables from old directory
cp /path/to/admin_panel/.env /path/to/pikkar_admin_panel/.env

# 4. Install dependencies
cd pikkar_admin_panel
npm install

# 5. Update your service configuration to point to new directory
# Edit your PM2/systemd config to use new path

# 6. Restart service
pm2 restart pikkar-api  # or: sudo systemctl restart pikkar-api

# 7. (Optional) Remove old directory after verifying everything works
# rm -rf /path/to/admin_panel
```

### Option 3: Using the Update Script

1. Copy `update_vps.sh` to your VPS
2. Edit the script and update the paths:
   - `OLD_DIR`: Your current admin_panel directory path
   - `NEW_DIR`: Where you want the new pikkar_admin_panel directory
3. Make it executable: `chmod +x update_vps.sh`
4. Run it: `./update_vps.sh`

## Important Notes

1. **Environment Variables**: Make sure to copy your `.env` file from the old directory
2. **Database**: No database changes needed - same MongoDB connection
3. **Service Restart**: Update your PM2/systemd configuration if directory path changed
4. **Logs**: Check logs after restart to ensure everything is working

## Verify Update

After updating, check:
- Service is running: `pm2 status` or `sudo systemctl status pikkar-api`
- Logs are clean: `pm2 logs pikkar-api` or check log files
- API is responding: `curl http://localhost:PORT/api/v1/health` (if health endpoint exists)

## Rollback (If needed)

If something goes wrong:
```bash
# Restore from backup
cp -r /path/to/admin_panel_backup_YYYYMMDD /path/to/admin_panel
cd /path/to/admin_panel
pm2 restart pikkar-api
```
