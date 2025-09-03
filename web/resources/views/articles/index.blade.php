<!DOCTYPE html>
<html>
<head>
    <title>News Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h1 class="mb-4">News Articles</h1>
        <a href="{{ route('articles.create') }}" class="btn btn-primary mb-3">Create New Article</a>

        @if(session('success'))
            <div class="alert alert-success">
                {{ session('success') }}
            </div>
        @endif

        <div class="row">
            @foreach($articles as $article)
            <div class="col-md-6 mb-4">
                <div class="card">
                    @if($article->image_url)
                    <img src="{{ $article->image_url }}" class="card-img-top" alt="{{ $article->title }}">
                    @endif
                    <div class="card-body">
                        <h5 class="card-title">{{ $article->title }}</h5>
                        <p class="card-text">{{ Str::limit($article->content, 100) }}</p>
                        <p class="text-muted">Category: {{ $article->category }}</p>
                        <p class="text-muted">Author: {{ $article->author }}</p>

                        <div class="d-flex gap-2">
                            <a href="{{ route('articles.show', $article->id) }}" class="btn btn-info btn-sm">View</a>
                            <a href="{{ route('articles.edit', $article->id) }}" class="btn btn-warning btn-sm">Edit</a>
                            <form action="{{ route('articles.destroy', $article->id) }}" method="POST">
                                @csrf
                                @method('DELETE')
                                <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            @endforeach
        </div>
    </div>
</body>
</html>
