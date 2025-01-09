<script>
    // 게시글 데이터를 저장하는 배열
    const posts = [];

    // 게시글 폼 제출 시 동작하는 함수
    document.getElementById("postForm").addEventListener("submit", function(event) {
        event.preventDefault(); // 페이지 새로 고침 방지

        // 제목과 내용 입력값 가져오기
        const title = document.getElementById("title").value;
        const content = document.getElementById("content").value;

        // 게시글 데이터 객체 만들기
        const newPost = {
            title: title,
            content: content,
            date: new Date().toLocaleString() // 현재 날짜
        };

        // 배열에 새 게시글 추가
        posts.push(newPost);

        // 입력값 초기화
        document.getElementById("title").value = "";
        document.getElementById("content").value = "";

        // 게시글 목록 갱신
        displayPosts();
    });


    // 게시글 목록을 화면에 표시하는 함수
    function displayPosts() {
        const board = document.getElementById("board");
        board.innerHTML = ""; // 기존 게시글 목록 비우기

        // 모든 게시글을 화면에 표시
        posts.forEach(function(post) {
            const postElement = document.createElement("div");
            postElement.classList.add("message");

            postElement.innerHTML = `
                <h3>${post.title} <span>${post.date}</span></h3>
                <p class="message-text">${post.content}</p>
            `;

            board.appendChild(postElement);
        });
    }
</script>
