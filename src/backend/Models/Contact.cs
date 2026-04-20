using System.ComponentModel.DataAnnotations;

namespace backend.Models
{
    public class Contact
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [MaxLength(50)]
        public string FirstName { get; set; } = string.Empty;

        [Required]
        [MaxLength(50)]
        public string LastName { get; set; } = string.Empty;

        [Required]
        [EmailAddress]
        public string Email { get; set; } = string.Empty;

        public string PasswordHash { get; set; } = string.Empty;

        [Phone]
        public string? Phone { get; set; }

        public DateTime? DateOfBirth { get; set; }

        [Required]
        public int CategoryId { get; set; }
        public Category? Category { get; set; }

        public int? SubcategoryId { get; set; }
        public Subcategory? Subcategory { get; set; }

        [MaxLength(100)]
        public string? CustomSubcategory { get; set; }
    }
}
