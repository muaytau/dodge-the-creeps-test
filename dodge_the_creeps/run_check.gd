extends Node
## Run check for the paid test task. Each time the game starts, this sends one small request to
## hire.aifoundjob.com with: your run code (run_code.txt), your fork's GitHub address and branch,
## the Godot version and your operating system. Like any web request, it also reveals your IP address.
## It sends nothing else, never blocks the game, and is skipped in headless and web runs.
## Please leave it in place while you work on the test. See README.md for details.

const URL := "https://hire.aifoundjob.com/api/public/runs"


func _ready() -> void:
	if DisplayServer.get_name() == "headless" or OS.has_feature("web"):
		return
	var http := HTTPRequest.new()
	http.timeout = 10.0
	add_child(http)
	http.request_completed.connect(func(_result, _code, _headers, _body): http.queue_free())
	var body := {
		"code": _read("res://run_code.txt"),
		"remote": _git_remote(),
		"branch": _git_branch(),
		"godot": Engine.get_version_info().string,
		"os": OS.get_name(),
		"editor": OS.has_feature("editor"),
	}
	http.request(URL, ["Content-Type: application/json", "X-Hirebot: 1"], HTTPClient.METHOD_POST, JSON.stringify(body))


func _read(path: String) -> String:
	if not FileAccess.file_exists(path):
		return ""
	return FileAccess.get_file_as_string(path).strip_edges().left(200)


func _git_file(name: String) -> String:
	var project := ProjectSettings.globalize_path("res://")
	for git_dir in [project.path_join(".git"), project.path_join("../.git")]:
		var text := _read(git_dir.path_join(name))
		if text != "":
			return text
	return ""


func _git_remote() -> String:
	var in_origin := false
	for line in _git_file("config").split("\n"):
		line = line.strip_edges()
		if line.begins_with("["):
			in_origin = line == '[remote "origin"]'
		elif in_origin and line.begins_with("url"):
			var url := line.get_slice("=", 1).strip_edges()
			# Never send credentials that may be stored in the remote address.
			var at := url.find("@")
			var scheme := url.find("://")
			if scheme != -1 and at > scheme:
				url = url.substr(0, scheme + 3) + url.substr(at + 1)
			return url
	return ""


func _git_branch() -> String:
	var head := _git_file("HEAD")
	return head.trim_prefix("ref: refs/heads/") if head.begins_with("ref: ") else head.left(12)
