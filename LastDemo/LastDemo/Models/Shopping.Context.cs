﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace LastDemo.Models
{
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    
    public partial class TESTEntities : DbContext
    {
        public TESTEntities()
            : base("name=TESTEntities")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<Category> Categories { get; set; }
        public virtual DbSet<Cloth> Clothes { get; set; }
        public virtual DbSet<Clothes_Color_Size> Clothes_Color_Size { get; set; }
        public virtual DbSet<ClothingStyle> ClothingStyles { get; set; }
        public virtual DbSet<ClothingType> ClothingTypes { get; set; }
        public virtual DbSet<Color> Colors { get; set; }
        public virtual DbSet<Image> Images { get; set; }
        public virtual DbSet<Size> Sizes { get; set; }
    }
}
