import { useState, useEffect } from 'react';
import axios from 'axios';

function App() {
  // --- CONTACT STATES ---
  const [contacts, setContacts] = useState([]);
  const [error, setError] = useState(null);

  // --- LOGIN STATES ---
  const [token, setToken] = useState(localStorage.getItem('token') || null);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loginError, setLoginError] = useState(null);

  // --- CREATE STATE ---
  const [newContact, setNewContact] = useState({
    firstName: '',
    lastName: '',
    email: '',
    passwordHash: '',
    categoryId: 1
  });

  // --- EDIT STATE ---
  const [editingContact, setEditingContact] = useState(null);

  const fetchContacts = async () => {
    try {
      const response = await axios.get('https://localhost:7282/api/contacts');
      setContacts(response.data);
    } catch (err) {
      console.error("Fetch error:", err);
      setError("Failed to connect to the server.");
    }
  };

  useEffect(() => {
    fetchContacts();
  }, []);

  // --- LOGIN / LOGOUT FUNCTIONS ---
  const handleLogin = async (e) => {
    e.preventDefault();
    setLoginError(null);

    try {
      const response = await axios.post('https://localhost:7282/api/auth/login', {
        email: email,
        password: password
      });

      const receivedToken = response.data.token;
      
      setToken(receivedToken);
      localStorage.setItem('token', receivedToken);
      
      setEmail('');
      setPassword('');
    } catch (err) {
      setLoginError("Invalid email or password.");
    }
  };

  const handleLogout = () => {
    setToken(null);
    localStorage.removeItem('token');
    setEditingContact(null);
  };

  // --- DELETE FUNCTION ---
  const handleDelete = async (id) => {
    if (!window.confirm("Are you sure you want to delete this contact?")) return;

    try {
      await axios.delete(`https://localhost:7282/api/contacts/${id}`, {
        headers: {
          Authorization: `Bearer ${token}`
        }
      });
      fetchContacts();
    } catch (err) {
      console.error("Delete error:", err);
      alert("Failed to delete contact.");
    }
  };

  // --- CREATE FUNCTION ---
  const handleCreate = async (e) => {
    e.preventDefault();
    try {
      await axios.post('https://localhost:7282/api/contacts', newContact, {
        headers: {
          Authorization: `Bearer ${token}`
        }
      });
      
      fetchContacts();
      setNewContact({ firstName: '', lastName: '', email: '', passwordHash: '', categoryId: 1 });
    } catch (err) {
      console.error("Create error:", err);
      alert("Failed to create contact.");
    }
  };

  // --- UPDATE FUNCTION ---
  const handleUpdate = async (e) => {
    e.preventDefault();
    
    // Clean data before sending to C# (convert empty strings to null)
    const payload = {
      ...editingContact,
      subcategoryId: editingContact.subcategoryId === '' ? null : parseInt(editingContact.subcategoryId),
      customSubcategory: editingContact.customSubcategory === '' ? null : editingContact.customSubcategory
    };

    try {
      await axios.put(`https://localhost:7282/api/contacts/${editingContact.id}`, payload, {
        headers: {
          Authorization: `Bearer ${token}`
        }
      });
      
      fetchContacts();
      setEditingContact(null);
    } catch (err) {
      console.error("Update error:", err);
      alert("Failed to update contact. Check console for details.");
    }
  };

  // --- PREPARE EDIT ---
  const startEdit = (contact) => {
    setEditingContact({
      id: contact.id,
      firstName: contact.firstName,
      lastName: contact.lastName,
      email: contact.email,
      passwordHash: '', 
      categoryId: contact.categoryId || 1,
      subcategoryId: contact.subcategoryId || '',
      customSubcategory: contact.customSubcategory || ''
    });
  };

  return (
    <div>
      <div>
        {token ? (
          <div>
            <h3>You are logged in</h3>
            <button onClick={handleLogout}>Logout</button>
          </div>
        ) : (
          <form onSubmit={handleLogin}>
            <h3>Login</h3>
            {loginError && <p>{loginError}</p>}
            <input 
              type="email" 
              placeholder="Email" 
              value={email} 
              onChange={(e) => setEmail(e.target.value)} 
              required 
            />
            <input 
              type="password" 
              placeholder="Password" 
              value={password} 
              onChange={(e) => setPassword(e.target.value)} 
              required 
            />
            <button type="submit">Login</button>
          </form>
        )}
      </div>

      <hr />

      {token && (
        <div>
          {editingContact ? (
            <div>
              <h2>Edit Contact</h2>
              <form onSubmit={handleUpdate}>
                <input 
                  type="text" 
                  placeholder="First Name" 
                  value={editingContact.firstName}
                  onChange={(e) => setEditingContact({...editingContact, firstName: e.target.value})}
                  required 
                />
                <input 
                  type="text" 
                  placeholder="Last Name" 
                  value={editingContact.lastName}
                  onChange={(e) => setEditingContact({...editingContact, lastName: e.target.value})}
                  required 
                />
                <input 
                  type="email" 
                  placeholder="Email" 
                  value={editingContact.email}
                  onChange={(e) => setEditingContact({...editingContact, email: e.target.value})}
                  required 
                />
                <input 
                  type="password" 
                  placeholder="New Password (leave blank to keep current)" 
                  value={editingContact.passwordHash}
                  onChange={(e) => setEditingContact({...editingContact, passwordHash: e.target.value})}
                />
                <select 
                  value={editingContact.categoryId}
                  onChange={(e) => setEditingContact({...editingContact, categoryId: parseInt(e.target.value)})}
                >
                  <option value={1}>Business</option>
                  <option value={2}>Private</option>
                  <option value={3}>Other</option>
                </select>
                <button type="submit">Save Changes</button>
                <button type="button" onClick={() => setEditingContact(null)}>Cancel</button>
              </form>
            </div>
          ) : (
            <div>
              <h2>Add New Contact</h2>
              <form onSubmit={handleCreate}>
                <input 
                  type="text" 
                  placeholder="First Name" 
                  value={newContact.firstName}
                  onChange={(e) => setNewContact({...newContact, firstName: e.target.value})}
                  required 
                />
                <input 
                  type="text" 
                  placeholder="Last Name" 
                  value={newContact.lastName}
                  onChange={(e) => setNewContact({...newContact, lastName: e.target.value})}
                  required 
                />
                <input 
                  type="email" 
                  placeholder="Email" 
                  value={newContact.email}
                  onChange={(e) => setNewContact({...newContact, email: e.target.value})}
                  required 
                />
                <input 
                  type="password" 
                  placeholder="Password" 
                  value={newContact.passwordHash}
                  onChange={(e) => setNewContact({...newContact, passwordHash: e.target.value})}
                  required 
                />
                <select 
                  value={newContact.categoryId}
                  onChange={(e) => setNewContact({...newContact, categoryId: parseInt(e.target.value)})}
                >
                  <option value={1}>Business</option>
                  <option value={2}>Private</option>
                  <option value={3}>Other</option>
                </select>
                <button type="submit">Add Contact</button>
              </form>
            </div>
          )}
        </div>
      )}

      <hr />

      <h1>Contact Book</h1>
      {error && <p>{error}</p>}
      {contacts.length === 0 && !error && <p>No contacts in the database.</p>}

      <ul>
        {contacts.map((contact) => (
          <li key={contact.id}>
            <strong>{contact.firstName} {contact.lastName}</strong>
            <div>
              Email: {contact.email} <br/>
              Category: {contact.categoryName} {contact.subcategory ? `> ${contact.subcategory}` : ''}
            </div>
            
            {token && (
              <div>
                <button onClick={() => startEdit(contact)}>Edit</button>
                <button onClick={() => handleDelete(contact.id)}>Delete</button>
              </div>
            )}
          </li>
        ))}
      </ul>
    </div>
  );
}

export default App;