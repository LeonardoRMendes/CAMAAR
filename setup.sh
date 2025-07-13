#!/bin/bash
# Setup script for development environment

echo "Setting up CAMAAR project..."

# Install dependencies
echo "Installing gems..."
bundle install

# Setup database
echo "Setting up database..."
rails db:create
rails db:migrate
rails db:seed

echo "Setup complete!"
echo ""
echo "To start the server, run:"
echo "  rails server"
echo ""
echo "Access the application at: http://localhost:3000"
echo ""
echo "Login credentials:"
echo "Admin: admin@unb.br / admin123"
echo "User: user@unb.br / user123"
