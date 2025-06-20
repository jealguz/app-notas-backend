<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\Route; // ¡Añade esta línea!

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        // ¡Añade este bloque para cargar tus rutas de API!
        Route::middleware('api')
            ->prefix('api')
            ->group(base_path('routes/api.php'));

        // Opcional: También puedes cargar las rutas web si lo necesitas y no están ya cargadas
        // Route::middleware('web')
        //     ->group(base_path('routes/web.php'));
    }
}
