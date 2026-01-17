/* ============================================
   COMMON JAVASCRIPT FUNCTIONS
   ============================================ */

// Close modal with ESC key
document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        const modals = document.querySelectorAll('.modal.active');
        modals.forEach(modal => modal.classList.remove('active'));
    }
});

// Close modal when clicking outside
window.addEventListener('click', function(event) {
    if (event.target.classList.contains('modal')) {
        event.target.classList.remove('active');
    }
});

// Auto-hide alerts after 5 seconds
document.addEventListener('DOMContentLoaded', function() {
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        setTimeout(() => {
            alert.style.opacity = '0';
            alert.style.transform = 'translateY(-20px)';
            setTimeout(() => alert.remove(), 300);
        }, 5000);
    });
});

// Confirm delete actions
function confirmDelete(message) {
    return confirm(message || 'Bạn có chắc muốn xóa?');
}

// Format number with commas
function formatNumber(num) {
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

// Format price (VND)
function formatPrice(price) {
    return formatNumber(price) + ' đ';
}

