const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { v4: uuidv4 } = require('uuid');

const app = express();
app.use(cors());
app.use(express.json());

const JWT_SECRET = 'futbol_stats_pro_2026_key';

const pool = new Pool({
  connectionString: process.env.DATABASE_URL
});

// Health check
app.get('/api/health', (req, res) => res.json({ status: 'ok', time: new Date() }));

// Auth: Register
app.post('/api/auth/register', async (req, res) => {
  const { username, email, password } = req.body;
  try {
    const hash = await bcrypt.hash(password, 10);
    const verificationToken = uuidv4();

    await pool.query(
      'INSERT INTO users (username, email, password_hash, is_verified, verification_token) VALUES ($1, $2, $3, false, $4)',
      [username, email, hash, verificationToken]
    );

    console.log(`\n📧 [EMAIL SIMULATOR] Enviando a: ${email}`);
    console.log(`🔗 Enlace de verificación: http://localhost:3000/api/auth/verify/${verificationToken}\n`);

    res.status(201).json({
      message: 'Usuario registrado. Revisa la consola o usa el botón de auto-verificación.',
      email: email // Devolvemos el email para ayudar al frontend
    });
  } catch (err) {
    res.status(500).json({ error: 'Usuario o email ya existe.' });
  }
});

// Auth: Get Token (Helper para testeo rápido sin mirar logs)
app.get('/api/auth/get-token/:email', async (req, res) => {
  try {
    const result = await pool.query('SELECT verification_token FROM users WHERE email = $1 AND is_verified = false', [req.params.email]);
    if (result.rows.length > 0) {
      res.json({ token: result.rows[0].verification_token });
    } else {
      res.status(404).json({ error: 'No se encontró token pendiente.' });
    }
  } catch (err) {
    res.status(500).json({ error: 'Error' });
  }
});

// Auth: Verify Email
app.get('/api/auth/verify/:token', async (req, res) => {
  const { token } = req.params;
  try {
    const result = await pool.query(
      'UPDATE users SET is_verified = true, verification_token = NULL WHERE verification_token = $1 RETURNING username',
      [token]
    );

    if (result.rows.length === 0) {
      return res.status(400).send('<h1>Error</h1><p>Token inválido o cuenta ya verificada.</p>');
    }

    res.send(`
      <div style="font-family:sans-serif; text-align:center; padding: 50px; background:#0f172a; color:white; min-height:100vh; display:flex; flex-direction:column; justify-content:center;">
        <h1 style="color:#22c55e; font-size:3rem; margin-bottom:10px;">⚽ Futbol Stats</h1>
        <h2 style="font-size:2rem;">¡Cuenta Verificada con Éxito!</h2>
        <p style="font-size:1.2rem; color:#94a3b8; margin-bottom:30px;">Hola <b>${result.rows[0].username}</b>, tu acceso premium ha sido activado.</p>
        <a href="http://localhost:5050" style="display:inline-block; padding:20px 40px; background:#22c55e; color:black; border-radius:15px; text-decoration:none; font-weight:900; letter-spacing:1px; transform: scale(1.1);">VOLVER A LA APP Y ENTRAR</a>
      </div>
    `);
  } catch (err) {
    res.status(500).send('Error en el servidor');
  }
});

// Auth: Login
app.post('/api/auth/login', async (req, res) => {
  const { email, password } = req.body;
  try {
    const result = await pool.query('SELECT * FROM users WHERE email = $1', [email]);
    if (result.rows.length === 0) return res.status(401).json({ error: 'Credenciales inválidas' });

    const user = result.rows[0];
    if (!user.is_verified) {
      return res.status(403).json({
        error: 'DEBES VERIFICAR TU CUENTA',
        needsVerification: true,
        email: email
      });
    }

    const valid = await bcrypt.compare(password, user.password_hash);
    if (!valid) return res.status(401).json({ error: 'Credenciales inválidas' });

    const token = jwt.sign({ id: user.id, username: user.username }, JWT_SECRET, { expiresIn: '24h' });
    res.json({ token, user: { id: user.id, username: user.username } });
  } catch (err) {
    res.status(500).json({ error: 'Error en el servidor' });
  }
});

// Leagues & Teams
app.get('/api/leagues', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM leagues ORDER BY id');
    res.json(result.rows);
  } catch (err) { res.status(500).json({ error: 'Error' }); }
});

app.get('/api/leagues/:id/teams', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM teams WHERE league_id = $1 ORDER BY name', [req.params.id]);
    res.json(result.rows);
  } catch (err) { res.status(500).json({ error: 'Error' }); }
});

// Matches & Stats
app.get('/api/matches', async (req, res) => {
  const { team, league_id } = req.query;
  try {
    let query = `SELECT m.*, ht.name as home_team, at.name as away_team FROM matches m JOIN teams ht ON m.home_team_id = ht.id JOIN teams at ON m.away_team_id = at.id`;
    const params = [];
    const conditions = [];
    if (team) {
      params.push(`%${team.toLowerCase()}%`);
      conditions.push(`(LOWER(ht.name) LIKE $${params.length} OR LOWER(at.name) LIKE $${params.length})`);
    }
    if (league_id) {
      params.push(league_id);
      conditions.push(`m.league_id = $${params.length}`);
    }
    if (conditions.length > 0) {
      query += ' WHERE ' + conditions.join(' AND ');
    }
    query += ' ORDER BY m.match_date DESC';
    const result = await pool.query(query, params);
    res.json(result.rows);
  } catch (err) { res.status(500).json({ error: 'Error' }); }
});

app.get('/api/matches/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const match = await pool.query(`SELECT m.*, ht.name as home_team, at.name as away_team FROM matches m JOIN teams ht ON m.home_team_id = ht.id JOIN teams at ON m.away_team_id = at.id WHERE m.id = $1`, [id]);
    const stats = await pool.query('SELECT * FROM match_stats WHERE match_id = $1', [id]);
    const players = await pool.query(`SELECT pms.*, p.name as player_name, p.position, t.name as team_name FROM player_match_stats pms JOIN players p ON pms.player_id = p.id JOIN teams t ON p.team_id = t.id WHERE pms.match_id = $1 ORDER BY pms.rating DESC`, [id]);
    res.json({ ...match.rows[0], stats: stats.rows, playerStats: players.rows });
  } catch (err) { res.status(500).json({ error: 'Error' }); }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`🚀 API v4 Auto-Verification running on port ${PORT}`));
