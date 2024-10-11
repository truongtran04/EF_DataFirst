using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using LastDemo.Models;
using LastDemo.Models.DAO;

namespace LastDemo.Areas.Admin.Controllers
{
    public class ClothesController : Controller
    {
        private TESTEntities db = new TESTEntities();

        // GET: Admin/Clothes
        public ActionResult Index()
        {
            var clothes = db.Clothes.Include(c => c.Category).Include(c => c.ClothingType).Include(c => c.ClothingStyle);
            return View(clothes.ToList());
        }

        // GET: Admin/Clothes/Details/5
        public ActionResult Details(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Cloth cloth = db.Clothes.Find(id);
            if (cloth == null)
            {
                return HttpNotFound();
            }
            return View(cloth);
        }

        // GET: Admin/Clothes/Create
        public ActionResult Create()
        {
            ViewBag.CategoryID = new SelectList(db.Categories, "CategoryID", "CategoryName");
            ViewBag.ClothingTypeID = new SelectList(db.ClothingTypes, "ClothingTypeID", "ClothingTypeName");
            ViewBag.ClothingStyleID = new SelectList(db.ClothingStyles, "ClothingStyleID", "ClothingStyleName");
            return View();
        }

        // POST: Admin/Clothes/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "ClothesID,ClothesName,Price,PriceSale,Description,Fabric,UserInstructions,CreatedAt,UpdatedAt,CategoryID,ClothingTypeID,ClothingStyleID,IsDeleted")] Cloth cloth)
        {
            if (ModelState.IsValid)
            {
                db.Clothes.Add(cloth);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.CategoryID = new SelectList(db.Categories, "CategoryID", "CategoryName", cloth.CategoryID);
            ViewBag.ClothingTypeID = new SelectList(db.ClothingTypes, "ClothingTypeID", "ClothingTypeName", cloth.ClothingTypeID);
            ViewBag.ClothingStyleID = new SelectList(db.ClothingStyles, "ClothingStyleID", "ClothingStyleName", cloth.ClothingStyleID);
            return View(cloth);
        }

        // GET: Admin/Clothes/Edit/5
        public ActionResult Edit(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Cloth cloth = db.Clothes.Find(id);
            if (cloth == null)
            {
                return HttpNotFound();
            }
            CategoriesDAO categoriesDAO = new CategoriesDAO();
            var clothingStyles = db.ClothingStyles.Where(row => row.ClothingTypeID == cloth.ClothingTypeID);
            ViewBag.CategoryID = new SelectList(categoriesDAO.getList("Index"), "CategoryID", "CategoryName", cloth.CategoryID);
            ViewBag.ClothingTypeID = new SelectList(db.ClothingTypes, "ClothingTypeID", "ClothingTypeName", cloth.ClothingTypeID);
            ViewBag.ClothingStyleID = new SelectList(clothingStyles, "ClothingStyleID", "ClothingStyleName", cloth.ClothingStyleID);
            return View(cloth);
        }

        // POST: Admin/Clothes/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "ClothesID,ClothesName,Price,PriceSale,Description,Fabric,UserInstructions,CreatedAt,UpdatedAt,CategoryID,ClothingTypeID,ClothingStyleID,IsDeleted")] Cloth cloth)
        {
            if (ModelState.IsValid)
            {
                db.Entry(cloth).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            CategoriesDAO categoriesDAO = new CategoriesDAO();
            var clothingStyles = db.ClothingStyles.Where(row => row.ClothingTypeID == cloth.ClothingTypeID);
            ViewBag.CategoryID = new SelectList(categoriesDAO.getList("Index"), "CategoryID", "CategoryName", cloth.CategoryID);
            ViewBag.ClothingTypeID = new SelectList(db.ClothingTypes, "ClothingTypeID", "ClothingTypeName", cloth.ClothingTypeID);
            ViewBag.ClothingStyleID = new SelectList(clothingStyles, "ClothingStyleID", "ClothingStyleName", cloth.ClothingStyleID);
            return View(cloth);
        }

        // GET: Admin/Clothes/Delete/5
        public ActionResult Delete(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Cloth cloth = db.Clothes.Find(id);
            if (cloth == null)
            {
                return HttpNotFound();
            }
            return View(cloth);
        }

        // POST: Admin/Clothes/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(string id)
        {
            Cloth cloth = db.Clothes.Find(id);
            db.Clothes.Remove(cloth);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}
