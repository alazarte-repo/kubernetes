#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.
#https://docs.microsoft.com/es-mx/visualstudio/containers/container-build?WT.mc_id=visualstudio_containers_aka_containerfastmode&view=vs-2022
# Get base Image from Microsoft
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 44326
EXPOSE 44336

# Get sdk image from microsoft
FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src

# Copy the csproj file and restore any dependencies
COPY ["SFIntegracionAPI/SFIntegracionAPI.csproj", "SFIntegracionAPI/"]
COPY ["SFIntegracionDAL/SFIntegracionDAL.csproj", "SFIntegracionDAL/"]
RUN dotnet restore "SFIntegracionAPI/SFIntegracionAPI.csproj"

# Copy the project files and build our release
COPY . .
WORKDIR "/src/SFIntegracionAPI"
RUN dotnet build "SFIntegracionAPI.csproj" -c Release -o /app/build

# Generate runtime image
FROM build AS publish
RUN dotnet publish "SFIntegracionAPI.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "SFIntegracionAPI.dll"]