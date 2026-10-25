using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using QuanLyDoAnAPI.Models;

namespace QuanLyDoAnAPI.Data;

public partial class QuanLyDoAnDbContext : DbContext
{
    public QuanLyDoAnDbContext(DbContextOptions<QuanLyDoAnDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<ChuyenNganh> ChuyenNganh { get; set; }

    public virtual DbSet<DeTai> DeTai { get; set; }

    public virtual DbSet<GiangVien> GiangVien { get; set; }

    public virtual DbSet<LoaiDoAn> LoaiDoAn { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<ChuyenNganh>(entity =>
        {
            entity.HasKey(e => e.MaChuyenNganh).HasName("PK__ChuyenNg__20FEA98D132D48E7");

            entity.Property(e => e.MaChuyenNganh)
                .HasMaxLength(10)
                .IsUnicode(false);
            entity.Property(e => e.MoTa).HasMaxLength(500);
            entity.Property(e => e.TenChuyenNganh).HasMaxLength(150);
        });

        modelBuilder.Entity<DeTai>(entity =>
        {
            entity.HasKey(e => e.MaDeTai).HasName("PK__DeTai__9F967D5B5C13D7E1");

            entity.HasIndex(e => e.MaChuyenNganh, "IX_DeTai_MaChuyenNganh");

            entity.HasIndex(e => e.MaLoaiDoAn, "IX_DeTai_MaLoaiDoAn");

            entity.Property(e => e.MaDeTai)
                .HasMaxLength(10)
                .IsUnicode(false);
            entity.Property(e => e.MaChuyenNganh)
                .HasMaxLength(10)
                .IsUnicode(false);
            entity.Property(e => e.MaGiangVien)
                .HasMaxLength(10)
                .IsUnicode(false);
            entity.Property(e => e.MaLoaiDoAn)
                .HasMaxLength(10)
                .IsUnicode(false);
            entity.Property(e => e.SoSinhVienToiDa).HasDefaultValue(2);
            entity.Property(e => e.TenDeTai).HasMaxLength(250);

            entity.HasOne(d => d.MaChuyenNganhNavigation).WithMany(p => p.DeTai)
                .HasForeignKey(d => d.MaChuyenNganh)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_DeTai_ChuyenNganh");

            entity.HasOne(d => d.MaGiangVienNavigation).WithMany(p => p.DeTai)
                .HasForeignKey(d => d.MaGiangVien)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_DeTai_GiangVien");

            entity.HasOne(d => d.MaLoaiDoAnNavigation).WithMany(p => p.DeTai)
                .HasForeignKey(d => d.MaLoaiDoAn)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_DeTai_LoaiDoAn");
        });

        modelBuilder.Entity<GiangVien>(entity =>
        {
            entity.HasKey(e => e.MaGiangVien).HasName("PK__GiangVie__C03BEEBADCD4EC52");

            entity.Property(e => e.MaGiangVien)
                .HasMaxLength(10)
                .IsUnicode(false);
            entity.Property(e => e.Email)
                .HasMaxLength(150)
                .IsUnicode(false);
            entity.Property(e => e.HoTen).HasMaxLength(100);
            entity.Property(e => e.HocVi).HasMaxLength(30);
        });

        modelBuilder.Entity<LoaiDoAn>(entity =>
        {
            entity.HasKey(e => e.MaLoaiDoAn).HasName("PK__LoaiDoAn__73391AD1C9BCFDC5");

            entity.Property(e => e.MaLoaiDoAn)
                .HasMaxLength(10)
                .IsUnicode(false);
            entity.Property(e => e.MoTa).HasMaxLength(500);
            entity.Property(e => e.TenLoaiDoAn).HasMaxLength(100);
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
