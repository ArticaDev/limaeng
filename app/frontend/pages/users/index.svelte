<script>
    let email = '';
  
    function requestDeletion() {
      if (window.confirm('Are you sure you want to delete your account? This action cannot be undone.')) {
        fetch('/api/v1/users/', {
          method: 'DELETE',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({ email }),
        }).then(() => {
          email = '';
          window.alert('Your account has been deleted.');
        });
      }
    }
  </script>

<div class="min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-md w-full space-y-8">
        <div>
            <h2 class="mt-6 text-center text-3xl font-extrabold text-gray-900">
                Request Account Deletion for Em Obras App
            </h2>
        </div>
        <div class="text-center">
            <p class="text-sm text-gray-600">
                This action cannot be undone. All your data in the "Em Obras" app will be permanently deleted.
            </p>
        </div>
        <form class="mt-8 space-y-6" on:submit|preventDefault={requestDeletion}>
            <input type="hidden" name="remember" value="true">
            <div class="rounded-md shadow-sm -space-y-px">
                <div>
                    <label for="email-address" class="sr-only">Email address</label>
                    <input id="email-address" name="email" type="email" required class="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-t-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm" placeholder="Email address" bind:value={email}>
                </div>
            </div>

            <div>
                <button type="submit" class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                    Request Deletion
                </button>
            </div>
        </form>
    </div>
</div>