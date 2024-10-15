using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using LastDemo.Models;
using LastDemo.Models.DAO;

namespace LastDemo.Library
{
    public class SelectItem
    {
        public static string CategoriesID(string categoryID)
        {
            using (TESTEntities db = new TESTEntities())
            {
                // Truy vấn trực tiếp CategoryID và CategoryName
                var categoryName = db.Categories
                    .Where(c => c.CategoryID == categoryID && c.IsHidden == false)
                    .Select(c => c.CategoryName)
                    .FirstOrDefault();

                // Nếu tìm thấy CategoryName, chuyển đổi sang slug
                if (categoryName != null)
                {
                    return XString.Str_Slug(categoryName); // Chuyển CategoryName sang slug
                }

                return null; // Trả về null nếu không tìm thấy
            }
        }


    }
}