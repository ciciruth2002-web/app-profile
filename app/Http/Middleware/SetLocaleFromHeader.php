<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class SetLocaleFromHeader
{
    /**
     * Handle an incoming request.
     */
    public function handle(Request $request, Closure $next): Response
    {
        $locale = $request->header('Accept-Language') ?? $request->query('locale');

        if ($locale) {
            $primary = strtolower(substr(trim($locale), 0, 2));
            if (in_array($primary, ['id', 'en'], true)) {
                app()->setLocale($primary);
            }
        }

        return $next($request);
    }
}
