//= require_tree .

document.addEventListener('DOMContentLoaded', function() {
    document.addEventListener('click', function(e) {
        const link = e.target.closest('a[data-turbo-method="delete"], a[data-method="delete"]');
        if (link) {
            const confirmMessage = link.getAttribute('data-turbo-confirm') || link.getAttribute('data-confirm');
            if (confirmMessage && !confirm(confirmMessage)) {
                e.preventDefault();
                return false;
            }
            
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = link.href;
            form.style.display = 'none';
            
            const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
            const csrfInput = document.createElement('input');
            csrfInput.type = 'hidden';
            csrfInput.name = 'authenticity_token';
            csrfInput.value = csrfToken;
            form.appendChild(csrfInput);
            
            const methodInput = document.createElement('input');
            methodInput.type = 'hidden';
            methodInput.name = '_method';
            methodInput.value = 'delete';
            form.appendChild(methodInput);
            
            document.body.appendChild(form);
            form.submit();
            
            e.preventDefault();
            return false;
        }
    });

    const flashMessages = document.querySelectorAll('.alert');
    flashMessages.forEach(function(message) {
        setTimeout(function() {
            message.style.opacity = '0';
            setTimeout(function() {
                message.remove();
            }, 300);
        }, 5000);
    });
});
