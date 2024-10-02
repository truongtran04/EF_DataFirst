using DataFirst.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace DataFirst.Controllers
{
    public class ClothesController : Controller
    {
        // GET: Clothes
        public ActionResult Index()
        {
            TESTEntities db = new TESTEntities();
            List<Cloth> clos = db.Clothes.ToList();

            return View(clos);
        }

        public ActionResult Create()
        {
            TESTEntities db = new TESTEntities();
            ViewBag.Categories = db.Categories.ToList();
            ViewBag.ClothingTypes = db.ClothingTypes.ToList();
            ViewBag.ClothingStyles = db.ClothingStyles.ToList();

            return View();
        }

        [HttpPost]
        public ActionResult Create(Cloth clos)
        {
            TESTEntities db = new TESTEntities();
            clos.ClothesID = "CTL000";
            db.Clothes.Add(clos);
            db.SaveChanges();

            return RedirectToAction("Index");
        }
    }
}