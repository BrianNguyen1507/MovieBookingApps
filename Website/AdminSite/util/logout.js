$(document).on("click", "#logoutButton", async function(event) {
    try {
        const confirmation = await Swal.fire({
            title: "Are you sure?",
            text: "Do you really want to log out?",
            icon: "warning",
            showCancelButton: true,
            confirmButtonText: "Yes, log out",
            cancelButtonText: "No, cancel",
        });

        if (confirmation.isConfirmed) {
            event.preventDefault();
            sessionStorage.clear();
            window.location.href = "./signin.html";
        }
    } catch (error) {
        console.error(error);
    }
});
