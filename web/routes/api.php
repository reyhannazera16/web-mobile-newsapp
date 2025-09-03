<?php

use App\Http\Controllers\API\ArticleController;
use Illuminate\Support\Facades\Route;

Route::apiResource('articles', ArticleController::class);
