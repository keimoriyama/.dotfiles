import { Denops, open, execute, globals, join, format, setbufline } from "./deps.ts"

export async function main(denops: Denops): Promise<void> {
	denops.dispatcher = {
		async open_file(filename: unknown) {
			const baseDir = await globals.get(denops, "base_dir");
			const path2file = join(baseDir, filename);
			open(denops, path2file)
		},
		async create_today() {
			const baseDir = await globals.get(denops, "base_dir");
			const filename = await gen_date_str();
			const path2file = join(baseDir, filename);
			const res = await open(denops, path2file)
			const bufnr = res['bufnr']
			const template = await get_template(filename, "daily_note")
			await setbufline(denops, bufnr, 1, template)
		}
	}
	await execute(
		denops,
		`command! ObsidianVimToday call denops#request('${denops.name}', 'create_today', [])`,
	)
}

async function get_template(id: string, tag: string): Promise<string[]> {
	const monthNames = ["January", "February", "March", "April", "May", "June",
		"July", "August", "September", "October", "November", "December"
	];
	const d = await get_date()
	const month = monthNames[d.getMonth() - 1]
	const date_alias = `- ${month} ${d.getDate()}, ${d.getFullYear()}`
	return [
		"---",
		`id: \"${id}\"`,
		"aliases:",
		date_alias,
		"tags:",
		`- \"${tag}\"`,
		"--- "
	]
}

async function get_date(): Promise<Date> {
	const d = new Date();
	return d;
}

async function gen_date_str(): Promise<string> {
	const d = await get_date();
	const filename = format(d, "yyyy-MM-dd") + ".md";
	return filename;
}