#!/bin/bash

# Simple AWS CodePipeline PostScript for Ruby on Rails
set -e

echo "🚀 Starting Rails deployment..."

# Go to app directory
cd /home/ec2-user/cicd

# Load environment variables (if using dotenv or system vars)
export RAILS_ENV=production

# Install Ruby dependencies
echo "📦 Installing gems..."
bundle install --deployment --without development test

# Run database migrations
echo "🗄️ Running database migrations..."
bundle exec rails db:migrate

# Precompile assets
echo "🎨 Precompiling assets..."
bundle exec rails assets:precompile

# Stop old Puma process if running
echo "🛑 Stopping old server..."
pkill -f "puma" 2>/dev/null || true
sleep 2

# Start Puma (or replace with Passenger/Unicorn as needed)
echo "▶️ Starting Puma server..."
nohup bundle exec puma -C config/puma.rb >> log/puma.log 2>&1 &
sleep 5

# Health check
echo "🔍 Checking if Rails app is running..."
if curl -f -s http://localhost:3000 > /dev/null; then
    echo "✅ Deployment successful! App is running on http://localhost:3000"
else
    echo "❌ Deployment failed!"
    exit 1
fi
