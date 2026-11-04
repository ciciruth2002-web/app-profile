<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\Setting;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class SettingController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $settings = Setting::query()
            ->when($request->filled('group'), fn ($q) => $q->where('group', $request->query('group')))
            ->get();

        $keyed = $settings->pluck('value', 'key')->all();

        return response()->json([
            'data' => $keyed,
            'details' => $settings,
        ]);
    }
}
