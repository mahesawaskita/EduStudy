
const express = require('express');
const router = express.Router();

const db = require('../config/database');
const { verifyToken, verifyAdmin } = require('../middleware/authMiddleware');

// Semua API di file ini hanya bisa diakses Admin yang sudah login
router.use(verifyToken, verifyAdmin);

// 1. Melihat semua data pendaftaran
router.get('/pendaftaran', (req, res) => {
    const sql = `
        SELECT 
            pendaftaran.*,
            users.nama,
            users.email
        FROM pendaftaran
        JOIN users ON pendaftaran.user_id = users.id
        ORDER BY pendaftaran.created_at DESC
    `;

    db.query(sql, (err, results) => {
        if (err) {
            return res.status(500).json({
                message: 'Gagal mengambil data pendaftaran',
                error: err.message
            });
        }

        res.json({
            message: 'Data pendaftaran berhasil diambil',
            data: results
        });
    });
});

// 2. Mengubah status pendaftaran
router.patch('/pendaftaran/:id/status', (req, res) => {
    const { status } = req.body;
    const { id } = req.params;

    const statusValid = ['Menunggu', 'Diterima', 'Ditolak'];

    if (!statusValid.includes(status)) {
        return res.status(400).json({
            message: 'Status tidak valid'
        });
    }

    const sql = 'UPDATE pendaftaran SET status = ? WHERE id = ?';

    db.query(sql, [status, id], (err, result) => {
        if (err) {
            return res.status(500).json({
                message: 'Gagal mengubah status',
                error: err.message
            });
        }

        if (result.affectedRows === 0) {
            return res.status(404).json({
                message: 'Data pendaftaran tidak ditemukan'
            });
        }

        res.json({
            message: 'Status pendaftaran berhasil diperbarui',
            status: status
        });
    });
});

module.exports = router;
