import React, { useState } from 'react';
import Loginhandler from '../pages/api/auth/login.js';
import Registerhandler from '../pages/api/auth/register.js';

function LoginRegisterForm() {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');

  const handleRegister = async (event) => {
    console.log('Registering user');
    event.preventDefault();
    try {
      const result = await Registerhandler({ email: username, password });
      console.log(result.message);
      alert('Erfolgreich registriert!');
    } catch (error) {
      console.error(error.message);
    }
  };

  const handleLogin = async (event) => {
    event.preventDefault();
    
      try {
      const data = await Loginhandler({ email: username, password });
      console.log('Login successful');
    } catch (error) {
      alert('Login failed: ' + error.message);
    }
  };

  return (
    <form>
      <input id="username" name="username" type="text" placeholder="Benutzername" value={username} onChange={(e) => setUsername(e.target.value)} required autoComplete="username" />
      <input id="password" name="password" type="password" placeholder="Passwort" value={password} onChange={(e) => setPassword(e.target.value)} required autoComplete="current-password" />
      <button type="button" onClick={handleLogin}>Anmelden</button>
      <button type="button" onClick={handleRegister}>Registrieren</button>
    </form>
  );
}

export default LoginRegisterForm;