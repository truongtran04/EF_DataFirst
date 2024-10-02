using DataFirst.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace DataFirst.Controllers
{
    public class QuantityController : Controller
    {
        // GET: Quantity
        public ActionResult Index()
        {
            TESTEntities db = new TESTEntities();
            List<Clothes_Color_Size> clothes_Color_Size = db.Clothes_Color_Size.ToList();
            return View(clothes_Color_Size);
        }

        public ActionResult Create()
        {
            TESTEntities db = new TESTEntities();

            ViewBag.Clothes = db.Clothes.ToList();
            ViewBag.Colors = db.Colors.ToList();
            ViewBag.Sizes = db.Sizes.ToList();

            return View();
        }


        // POST: Quantity/Create
        [HttpPost]
        public ActionResult Create(string ClothesID, string ColorID, List<Clothes_Color_Size> Sizes)
        {
            TESTEntities db = new TESTEntities();

            foreach (var item in Sizes)
            {
                var clothesColorSize = new Clothes_Color_Size
                {
                    ClothesID = ClothesID,
                    ColorID = ColorID,
                    SizeID = item.SizeID,
                    Quantity = item.Quantity
                };
                db.Clothes_Color_Size.Add(clothesColorSize);
            }

            db.SaveChanges();
            return RedirectToAction("Index");
        }
    }
}