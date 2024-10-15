using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using LastDemo.Models;
using LastDemo.Models.DAO;
using LastDemo.Library;

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
        public ActionResult Create(Cloth cloth)
        {
            if (ModelState.IsValid)
            {
                if (cloth.ClothesID == null)
                {
                    cloth.ClothesID = "CLT000";
                }
                //Upload file
                var image = Request.Files["MainImage"]; // lấy thông tin file
                if (image.ContentLength != 0)
                {
                    string[] FileExtentions = new string[] { ".jpg", ".jpeg", ".png" };
                    // Kiểm tra file
                    if (FileExtentions.Contains(image.FileName.Substring(image.FileName.LastIndexOf("."))))
                    {
                        //Upload hình
                        string imageName = XString.Str_Slug(cloth.ClothesName) + image.FileName.Substring(image.FileName.LastIndexOf("."));
                        cloth.MainImage = imageName;
                        string categoryFolder = SelectItem.CategoriesID(cloth.CategoryID);
                        string PathDir = $"~/Content/images/clothes/{categoryFolder}/"; // đường dẫn
                        string PathFile = Path.Combine(Server.MapPath(PathDir), imageName);
                        image.SaveAs(PathFile);
                    }
                }
                // end upload
                db.Clothes.Add(cloth);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.CategoryID = new SelectList(db.Categories, "CategoryID", "CategoryName", cloth.CategoryID);
            ViewBag.ClothingTypeID = new SelectList(db.ClothingTypes, "ClothingTypeID", "ClothingTypeName", cloth.ClothingTypeID);
            ViewBag.ClothingStyleID = new SelectList(db.ClothingStyles, "ClothingStyleID", "ClothingStyleName", cloth.ClothingStyleID);
            return View(cloth);
        }
        public JsonResult GetClothingStyles(string clothingTypeID)
        {
            var clothingStyles = db.ClothingStyles
                                   .Where(cs => cs.ClothingTypeID == clothingTypeID)
                                   .Select(cs => new { cs.ClothingStyleID, cs.ClothingStyleName })
                                   .ToList();
            return Json(clothingStyles, JsonRequestBehavior.AllowGet);
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
        public ActionResult Edit(Cloth cloth)
        {
            if (ModelState.IsValid)
            {
                //Upload file
                var image = Request.Files["MainImage"]; // lấy thông tin file
                if (image.ContentLength != 0)
                {
                    string[] FileExtentions = new string[] { ".jpg", ".jpeg", ".png" };
                    // Kiểm tra file
                    if (FileExtentions.Contains(image.FileName.Substring(image.FileName.LastIndexOf("."))))
                    {
                        //Upload hình
                        string clothesName = XString.Str_Slug(cloth.ClothesName);
                        string imageName = clothesName + image.FileName.Substring(image.FileName.LastIndexOf("."));
                        cloth.MainImage = imageName;
                        string PathDir = "~/Content/images/clothes/"; // đường dẫn
                        string PathFile = Path.Combine(Server.MapPath(PathDir), imageName);
                        if(cloth.MainImage.Length > 0)
                        {
                            string DelFile = Path.Combine(Server.MapPath(PathDir), cloth.MainImage);
                            System.IO.File.Delete(DelFile); // xóa hình cũ
                        }
                        image.SaveAs(PathFile);
                    }
                }
                // end upload
                // Fetch the original cloth record to retain the CreatedAt value
                var existingCloth = db.Clothes.AsNoTracking().FirstOrDefault(c => c.ClothesID == cloth.ClothesID);
                if (existingCloth != null)
                {
                    // Retain the original CreatedAt value
                    cloth.CreatedAt = existingCloth.CreatedAt;

                    // Update the UpdatedAt value to current time
                    cloth.UpdatedAt = DateTime.Now;

                    db.Entry(cloth).State = EntityState.Modified;
                    db.SaveChanges();

                    return RedirectToAction("Index");
                }
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
            
            string PathDir = "~/Content/images/clothes/";
            //Xóa hình ảnh
            if (cloth.MainImage != null)
            {
                string DelFile = Path.Combine(Server.MapPath(PathDir), cloth.MainImage);
                System.IO.File.Delete(DelFile); // xóa hình cũ
            }
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
