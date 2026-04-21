using System.ComponentModel.DataAnnotations;

namespace backend.Models
{
    public class Category
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [MaxLength(50)]
        public string Name { get; set; } = string.Empty;
        public ICollection<Subcategory> Subcategories { get; set; } = new List<Subcategory>();
    }
}
