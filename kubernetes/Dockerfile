# Base image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app

# Copy published files
COPY out/ .

# Expose port
EXPOSE 80

# Start the application
ENTRYPOINT ["dotnet", "easy-devops.dll"]
