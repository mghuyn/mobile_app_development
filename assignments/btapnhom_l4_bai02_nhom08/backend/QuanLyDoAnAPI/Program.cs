
using Microsoft.EntityFrameworkCore;
using QuanLyDoAnAPI.Data;

var builder = WebApplication.CreateBuilder(args);

// Dang ky Controller
builder.Services.AddControllers();

// Ket noi SQL Server
builder.Services.AddDbContext<QuanLyDoAnDbContext>(options =>
    options.UseSqlServer(
        builder.Configuration.GetConnectionString("QuanLyDoAnDB")
    )
);

// Cau hinh CORS cho Flutter
builder.Services.AddCors(options =>{
    options.AddPolicy("FlutterApp", policy => {
        policy.AllowAnyOrigin().AllowAnyMethod() .AllowAnyHeader();
    });
});

var app = builder.Build();

app.UseCors("FlutterApp");
app.MapControllers();

app.Run();
