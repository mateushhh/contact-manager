using backend.Data;
using backend.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Authorization;

namespace backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ContactsController : ControllerBase
    {
        private readonly AppDbContext _context;

        public ContactsController(AppDbContext context)
        {
            _context = context;
        }

        // GET/
        [HttpGet]
        public async Task<IActionResult> GetContacts()
        {
            var contacts = await _context.Contacts
                .Include(c => c.Category)
                .Select(c => new
                {
                    c.Id,
                    c.FirstName,
                    c.LastName,
                    c.Email,
                    CategoryName = c.Category.Name
                })
                .ToListAsync();

            // 200 OK
            return Ok(contacts);
        }

        // GET/id
        [HttpGet("{id}")]
        public async Task<IActionResult> GetContact(int id)
        {
            var contact = await _context.Contacts
                .Include(c => c.Category)
                .Include(c => c.Subcategory)
                .FirstOrDefaultAsync(c => c.Id == id);

            // 404 Not Found
            if (contact == null) return NotFound();

            // 200 OK
            return Ok(new
            {
                contact.Id,
                contact.FirstName,
                contact.LastName,
                contact.Email,
                //contact.PasswordHash,
                contact.Phone,
                contact.DateOfBirth,
                Category = contact.Category.Name,
                Subcategory = contact.Subcategory != null ? contact.Subcategory.Name : contact.CustomSubcategory
            });
        }

        // POST/
        [Authorize]
        [HttpPost]
        public async Task<IActionResult> CreateContact([FromBody] Contact newContact)
        {
            var passwordHasher = new PasswordHasher<Contact>();
            newContact.PasswordHash = passwordHasher.HashPassword(newContact, newContact.PasswordHash);

            _context.Contacts.Add(newContact);
            await _context.SaveChangesAsync();

            // 201 Created
            return CreatedAtAction(nameof(GetContact), new { id = newContact.Id }, new { id = newContact.Id, message = "Contact created" });
        }

        // PUT/id
        [Authorize]
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateContact(int id, [FromBody] Contact updatedContact)
        {
            if (id != updatedContact.Id) return BadRequest("Ids do not match");

            var existingContact = await _context.Contacts.FindAsync(id);
            if (existingContact == null) return NotFound("Contact not found");

            existingContact.FirstName = updatedContact.FirstName;
            existingContact.LastName = updatedContact.LastName;
            existingContact.Email = updatedContact.Email;
            existingContact.Phone = updatedContact.Phone;
            existingContact.DateOfBirth = updatedContact.DateOfBirth;
            existingContact.CategoryId = updatedContact.CategoryId;
            existingContact.SubcategoryId = updatedContact.SubcategoryId;
            existingContact.CustomSubcategory = updatedContact.CustomSubcategory;

            if (!string.IsNullOrEmpty(updatedContact.PasswordHash))
            {
                var passwordHasher = new Microsoft.AspNetCore.Identity.PasswordHasher<Contact>();
                existingContact.PasswordHash = passwordHasher.HashPassword(existingContact, updatedContact.PasswordHash);
            }

            await _context.SaveChangesAsync();
            return Ok("Contact updated");
        }

        // DELETE/id
        [Authorize]
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteContact(int id)
        {
            var contact = await _context.Contacts.FindAsync(id);
            if (contact == null) return NotFound("Contact not found");

            _context.Contacts.Remove(contact);
            await _context.SaveChangesAsync();

            return Ok("Contact removed");
        }
    }
}
