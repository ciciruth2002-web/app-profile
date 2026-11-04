<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\Api\V1\MenuResource;
use App\Models\Menu;

class MenuController extends Controller
{
    public function show(string $location): MenuResource
    {
        $menu = Menu::query()
            ->where('location', $location)
            ->where('is_active', true)
            ->with(['rootItems' => fn ($q) => $q->where('is_active', true)->with('children')])
            ->firstOrFail();

        return new MenuResource($menu);
    }
}
