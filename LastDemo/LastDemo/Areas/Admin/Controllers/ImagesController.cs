using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using LastDemo.Models;

namespace LastDemo.Areas.Admin.Controllers
{
    public class ImagesController : Controller
    {
        private TESTEntities db = new TESTEntities();

        // GET: Admin/Images
        public ActionResult Index()
        {
            var images = db.Images.Include(i => i.Cloth).Include(i => i.Color);
            return View(images.ToList());
        }

        // GET: Admin/Images/Details/5
        public ActionResult Details(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Image image = db.Images.Find(id);
            if (image == null)
            {
                return HttpNotFound();
            }
            return View(image);
        }

        // GET: Admin/Images/Create
        public ActionResult Create()
        {
            ViewBag.ClothesID = new SelectList(db.Clothes, "ClothesID", "ClothesName");
            ViewBag.ColorID = new SelectList(db.Colors, "ColorID", "ColorName");
            return View();
        }

        // POST: Admin/Images/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "ImageID,ImageName,MainImage,SecondaryImage1,SecondaryImage2,SecondaryImage3,ClothesID,ColorID,IsHidden")] Image image)
        {
            if (ModelState.IsValid)
            {
                db.Images.Add(image);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.ClothesID = new SelectList(db.Clothes, "ClothesID", "ClothesName", image.ClothesID);
            ViewBag.ColorID = new SelectList(db.Colors, "ColorID", "ColorName", image.ColorID);
            return View(image);
        }

        // GET: Admin/Images/Edit/5
        public ActionResult Edit(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Image image = db.Images.Find(id);
            if (image == null)
            {
                return HttpNotFound();
            }
            ViewBag.ClothesID = new SelectList(db.Clothes, "ClothesID", "ClothesName", image.ClothesID);
            ViewBag.ColorID = new SelectList(db.Colors, "ColorID", "ColorName", image.ColorID);
            return View(image);
        }

        // POST: Admin/Images/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "ImageID,ImageName,MainImage,SecondaryImage1,SecondaryImage2,SecondaryImage3,ClothesID,ColorID,IsHidden")] Image image)
        {
            if (ModelState.IsValid)
            {
                db.Entry(image).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.ClothesID = new SelectList(db.Clothes, "ClothesID", "ClothesName", image.ClothesID);
            ViewBag.ColorID = new SelectList(db.Colors, "ColorID", "ColorName", image.ColorID);
            return View(image);
        }

        // GET: Admin/Images/Delete/5
        public ActionResult Delete(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Image image = db.Images.Find(id);
            if (image == null)
            {
                return HttpNotFound();
            }
            return View(image);
        }

        // POST: Admin/Images/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(string id)
        {
            Image image = db.Images.Find(id);
            db.Images.Remove(image);
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
