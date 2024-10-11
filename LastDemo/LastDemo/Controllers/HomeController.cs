using LastDemo.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using LastDemo.Models.DAO;

namespace LastDemo.Controllers
{
    public class HomeController : Controller
    {
        // GET: Home
        public ActionResult Index()
        {
            TESTEntities db = new TESTEntities();
            CategoriesDAO categoriesDAO = new CategoriesDAO();
            ViewBag.Categories = categoriesDAO.getList("Index");
            ViewBag.ClothingTypes = db.ClothingTypes.ToList();
            return View();
        }
    }
}