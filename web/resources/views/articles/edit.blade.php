<!DOCTYPE html>
<html>
<head>
    <title>Edit Article</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h1 class="mb-4">Edit Article</h1>

        <form action="{{ route('articles.update', $article->id) }}" method="POST">
            @csrf
            @method('PUT')
            <div class="mb-3">
                <label for="title" class="form-label">Title</label>
                <input type="text" class="form-control" id="title" name="title" value="{{ $article->title }}" required>
            </div>

            <div class="mb-3">
                <label for="content" class="form-label">Content</label>
                <textarea class="form-control" id="content" name="content" rows="5" required>{{ $article->content }}</textarea>
            </div>

            <div class="mb-3">
                <label for="category" class="form-label">Category</label>
                <input type="text" class="form-control" id="category" name="category" value="{{ $article->category }}" required>
            </div>

            <div class="mb-3">
                <label for="image_url" class="form-label">Image URL (optional)</label>
                <input type="url" class="form-control" id="image_url" name="image_url" value="{{ $article->image_url }}">
            </div>

            <div class="mb-3">
                <label for="author" class="form-label">Author</label>
                <input type="text" class="form-control" id="author" name="author" value="{{ $article->author }}" required>
            </div>

            <button type="submit" class="btn btn-primary">Update Article</button>
            <a href="{{ route('articles.index') }}" class="btn btn-secondary">Cancel</a>
        </form>
    </div>
</body>
</html>
