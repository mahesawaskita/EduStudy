
require('dotenv').config();

const express = require('express');
const cors = require('cors');

const db = require('./config/database');
const authRoutes = require('./routes/auth');
const adminRoutes = require('./routes/admin');
const pendaftaranRoutes = require('./routes/pendaftaran');
const app = express();

app.use(cors());
app.use(express.json());
app.use('/api/auth', authRoutes);
app.use('/api/admin', adminRoutes);
app.use('/api/pendaftaran', pendaftaranRoutes);

// Halaman utama
app.get('/', (req, res) => {
    res.json({
        message: 'Backend PPDB berhasil berjalan!'
    });
});

// Tes database
app.get('/test-db', (req, res) => {
    db.query('SELECT 1 AS hasil', (err, result) => {
        if (err) {
            return res.status(500).json({
                message: 'Database gagal diakses'
            });
        }

        res.json({
            message: 'Database berhasil terhubung!',
            data: result
        });
    });
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log(`Server berjalan di http://localhost:${PORT}`);
});
