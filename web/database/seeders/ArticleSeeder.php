<?php

namespace Database\Seeders;

use App\Models\Article;
use Illuminate\Database\Seeder;

class ArticleSeeder extends Seeder
{
    public function run()
    {
        Article::create([
            'title' => 'Contoh Berita Teknologi',
            'content' => 'Ini adalah contoh berita teknologi yang menarik untuk dibaca...',
            'category' => 'Teknologi',
            'image_url' => 'https://picsum.photos/800/400',
            'author' => 'Admin'
        ]);

        Article::create([
            'title' => 'Berita Olahraga Terkini',
            'content' => 'Update terbaru dari dunia olahraga...',
            'category' => 'Olahraga',
            'image_url' => 'https://picsum.photos/800/400',
            'author' => 'Reporter Olahraga'
        ]);
    }
}
