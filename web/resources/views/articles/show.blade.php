<!DOCTYPE html>
<html>
<head>
    <title>{{ $article->title }}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <a href="{{ route('articles.index') }}" class="btn btn-secondary mb-3">Back to Articles</a>

        <article>
            @if($article->image_url)
            <img src="{{ $article->image_url }}" class="img-fluid mb-4" alt="{{ $article->title }}">
            @endif

            <h1 class="mb-3">{{ $article->title }}</h1>

            <div class="text-muted mb-3">
                <p>Category: {{ $article->category }} | Author: {{ $article->author }} | Published: {{ $article->created_at->format('M d, Y') }}</p>
            </div>

            <div class="article-content">
                {!! nl2br(e($article->content)) !!}
            </div>

            <div class="mt-4">
                <a href="{{ route('articles.edit', $article->id) }}" class="btn btn-warning">Edit</a>
                <form action="{{ route('articles.destroy', $article->id) }}" method="POST" class="d-inline">
                    @csrf
                    @method('DELETE')
                    <button type="submit" class="btn btn-danger" onclick="return confirm('Are you sure?')">Delete</button>
                </form>
            </div>
        </article>
    </div>
</body>
</html>
