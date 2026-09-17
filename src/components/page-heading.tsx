export function PageHeading({ title, body }: { title: string; body?: string }) {
  return (
    <div className="mb-8">
      <h1 className="text-3xl font-semibold tracking-tight text-stone-950 sm:text-4xl">{title}</h1>
      {body ? <p className="mt-3 max-w-2xl text-base leading-7 text-stone-600">{body}</p> : null}
    </div>
  );
}
